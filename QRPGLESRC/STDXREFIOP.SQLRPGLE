      **********************************************************************************************
      *                                                                                            *
      *  STANDARD CROSS REFERENCE I/O PROCEDURES                                                   *
      *                                                                                            *
      *  Copyright (C) 2006, 2021  Christopher F. Burns Sr.                                        *
      *                                                                                            *
      *  This program is free software: you can redistribute it and/or modify                      *
      *  it under the terms of the GNU General Public License as published by                      *
      *  the Free Software Foundation, either version 3 of the License, or                         *
      *  (at your option) any later version.                                                       *
      *                                                                                            *
      *  This program is distributed in the hope that it will be useful,                           *
      *  but WITHOUT ANY WARRANTY; without even the implied warranty of                            *
      *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                             *
      *  GNU General Public License for more details.                                              *
      *                                                                                            *
      *  You should have received a copy of the GNU General Public License                         *
      *  along with this program.  If not, see <http://www.gnu.org/licenses/>.                     *
      *                                                                                            *
      **********************************************************************************************

      /copy qcpysrc,stdhsrvpgm                                               // std control specs
      /copy qcpysrc,stdxrefiop                                               // std xref I/O procs
      /copy qcpysrc,stdpgmsts                                                // std prog status DS

       dcl-f StdXrefLst printer usropn infds(PrintInf);                      // hardcopy listing
       dcl-f StdXrefIOP workstn usropn sfile(FindXrefS1:sflrr1)
                                       sfile(FindXrefS2:sflrr2)
                                       sfile(FindXrefS3:sflrr3);             // search windows

       dcl-ds PrintInf qualified;                                            // printer info d/s
         OvflLine int(5)  pos(188);                                          // overflow line
         CurrLine int(5)  pos(367);                                          // current line number
         CurrPage int(10) pos(369);                                          // current page number
       end-ds;                                                               // printer info d/s

       dcl-ds Ind based(iptr) qualified;                                     // screen indicators
         Exit        ind pos(03);                                            // f3 to exit
         Cancel      ind pos(12);                                            // f12 to cancel
         EnableSFL   ind pos(31);                                            // enable subfile
         EnableOpt   ind pos(41);                                            // enable option colm
         ShowNumArg  ind pos(42);                                            // show numeric arg
         ShowDateArg ind pos(43);                                            // show numeric arg
       end-ds;                                                               // screen indicators

       dcl-s sflrr1 int(5);                                                  // SFL #1 record number
       dcl-s sflrr2 int(5);                                                  // SFL #2 record number
       dcl-s sflrr3 int(5);                                                  // SFL #3 record number
       dcl-s iptr pointer inz(%addr(*in));                                   // pointer to indicator

      **********************************************************************************************
      *
      *  Search for a numeric argument in a specified reference table.

       dcl-proc FindXrefNum export;                                          // find xref num arg

       dcl-pi FindXrefNum like(StdXrefI.NumArg);                             // find xref num arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.NumArg)   const options(*nopass);            // previous value
       end-pi;                                                               // find xref num arg

       dcl-s SelectedArg like(StdXrefI.NumArg);                              // selected num arg

       open StdXrefIOP;                                                      // open display file

       c2RefTable = RefTable;                                                // reference table

       exec sql declare FindXrefNumX1 cursor for
         select RefTable, NumArg, CharRes from StdXref
           where  RefTable = :RefTable
             and  NumArg  >= :c2NumArg
             and  CharArg <> :Marker
             and  Hidden  <> 'Y'
               order by 2;                                                   // ordering by arg

       exec sql declare FindXrefNumX2 cursor for
         select RefTable, NumArg, CharRes from StdXref
           where RefTable  = :RefTable
             and CharRes  >= :c2CharRes
             and CharArg  <> :Marker
             and  Hidden  <> 'Y'
               order by 3;                                                   // ordering by desc

       dou Ind.Cancel or SelectedArg > 0;                                    // until canc or select

         Ind.EnableSFL  = *off;                                              // disable subfile
         Ind.EnableOpt  = *off;                                              // disable option colm
         Ind.ShowNumArg = *off;                                              // hide numeric arg

         write findxrefc2;                                                   // clear subfile
         clear findxrefs2;                                                   // clear all fields
         clear sflrr2;                                                       // SFL record number

         Ind.EnableSFL = *on;                                                // enable subfile

         if c2CharRes > *blanks;                                             // if search on result
           exec sql open findxrefnumx2;                                      // open its cursor
         else;                                                               // search on argument
           exec sql open findxrefnumx1;                                      // open its cursor
         endif;                                                              // if search on result

         dou sqlcod <> 0 or %eof(StdXrefIOP);                                // until no more rows

           if c2CharRes > *blanks;                                           // if search on result
             exec sql fetch from findxrefnumx2
               into :s2RefTable, :s2NumArg, :s2CharRes;                      // fetch table entry
           else;                                                             // search on arg
             exec sql fetch from findxrefnumx1
               into :s2RefTable, :s2NumArg, :s2CharRes;                      // fetch table entry
           endif;                                                            // if search on result

           if sqlcod = *zeros;                                               // if successful fetch
             Ind.EnableOpt  = *on;                                           // enable option colm
             Ind.ShowNumArg = *on;                                           // show numeric arg
             sflrr2 += 1;                                                    // SFL record number
             write findxrefs2;                                               // write SFL record
           endif;                                                            // if successful fetch

         enddo;                                                              // until no more rows

         if c2CharRes > *blanks;                                             // if search on result
           exec sql close findxrefnumx2;                                     // close its cursor
         else;                                                               // search on argument
           exec sql close findxrefnumx1;                                     // close its cursor
         endif;                                                              // if search on result

         if sflrr2 = *zeros;                                                 // if subfile empty
           s2CharRes = 'NO ENTRIES FOUND';                                   // show relevant text
           sflrr2 = 2;                                                       // SFL record number
           write findxrefs2;                                                 // write SFL record
         endif;                                                              // if subfile empty

         exfmt findxrefc2;                                                   // pop search window

         if not Ind.Cancel;                                                  // if enter pressed

           clear sflrr2;                                                     // SFL record number

           dou %eof(StdXrefIOP) or s2select > *blanks;                       // until end or select
             readc findxrefs2;                                               // read subfile record
           enddo;                                                            // until end or select

           if s2select > *blanks;                                            // if entry selected
             selectedArg = s2NumArg;                                         // capture selection
           endif;                                                            // if entry selected

         endif;                                                              // if enter pressed
       enddo;                                                                // until canc or select

       if Ind.Cancel and %parms >= 2;                                        // if user cancels
         selectedArg = prvvalue;                                             // return prev value
       endif;                                                                // if user cancels

       close StdXrefIOP;                                                     // close display file
       return selectedArg;                                                   // return selection

       end-proc;                                                             // find xref num arg

      **********************************************************************************************
      *
      *  Search for a character argument in a specified reference table.

       dcl-proc FindXrefChar export;                                         // find xref char arg

       dcl-pi FindXrefChar like(StdXrefI.CharArg);                           // find xref char arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.CharArg)  const options(*nopass);            // previous value
       end-pi;                                                               // find xref char arg

       dcl-s SelectedArg like(StdXrefI.CharArg);                             // selected char arg

       open StdXrefIOP;                                                      // open display file

       c1RefTable = RefTable;                                                // reference table

       exec sql declare FindXrefCharX1 cursor for
         select RefTable, CharArg, CharRes from StdXref
           where  RefTable  = :RefTable
             and  CharArg  >= :c1CharArg
             and  CharArg  <> :Marker
             and  Hidden   <> 'Y'
               order by 2;                                                   // ordering by arg

       exec sql declare findxrefcharx2 cursor for
         select RefTable, CharArg, CharRes from StdXref
           where  RefTable  = :RefTable
             and  CharRes  >= :c1CharRes
             and  CharArg  <> :Marker
             and  Hidden   <> 'Y'
               order by 3;                                                   // ordering by desc

       dou Ind.Cancel or SelectedArg > *blanks;                              // until canc or select

         Ind.EnableSFL = *off;                                               // disable subfile
         Ind.EnableOpt = *off;                                               // disable option colm

         write findxrefc1;                                                   // clear subfile
         clear findxrefs1;                                                   // clear all fields
         clear sflrr1;                                                       // SFL record number

         Ind.EnableSFL = *on;                                                // enable subfile

         if c1CharRes > *blanks;                                             // if search on result
           exec sql open findxrefcharx2;                                     // open its cursor
         else;                                                               // search on argument
           exec sql open findxrefcharx1;                                     // open its cursor
         endif;                                                              // if search on result

         dou sqlcod <> *zeros or %eof(StdXrefIOP);                           // until no more rows

           if c1CharRes > *blanks;                                           // if search on result
             exec sql fetch from findxrefcharx2
               into :s1RefTable, :s1CharArg, :s1CharRes;                     // fetch table entry
           else;                                                             // search on arg
             exec sql fetch from findxrefcharx1
               into :s1RefTable, :s1CharArg, :s1CharRes;                     // fetch table entry
           endif;                                                            // if search on result

           if sqlcod = *zeros;                                               // if successful fetch
             Ind.EnableOpt = *on;                                            // enable option colm
             sflrr1 += 1;                                                    // SFL record number
             write findxrefs1;                                               // write SFL record
           endif;                                                            // if successful fetch

         enddo;                                                              // until no more rows

         if c1CharRes > *blanks;                                             // if search on result
           exec sql close findxrefcharx2;                                    // close its cursor
         else;                                                               // search on argument
           exec sql close findxrefcharx1;                                    // close its cursor
         endif;                                                              // if search on result

         if sflrr1 = 0;                                                      // if subfile empty
           s1CharRes = 'NO ENTRIES FOUND';                                   // show relevant text
           sflrr1 = 2;                                                       // SFL record number
           write findxrefs1;                                                 // write SFL record
         endif;                                                              // if subfile empty

         exfmt findxrefc1;                                                   // pop search window

         if not Ind.Cancel;                                                  // if enter pressed

           clear sflrr1;                                                     // SFL record number

           dou %eof(StdXrefIOP) or s1select > *blanks;                       // until end or select
             readc findxrefs1;                                               // read subfile record
           enddo;                                                            // until end or select

           if s1select > *blanks;                                            // if entry selected
             selectedArg = s1CharArg;                                        // capture selection
           endif;                                                            // if entry selected

         endif;                                                              // if enter pressed
       enddo;                                                                // until canc or select

       if Ind.Cancel and %parms >= 2;                                        // if user cancels
         selectedArg = prvvalue;                                             // return prev value
       endif;                                                                // if user cancels

       close StdXrefIOP;                                                     // close display file
       return SelectedArg;                                                   // return selection

       end-proc;                                                             // find xref char arg

      **********************************************************************************************
      *
      *  Pops a window to confirm the deletion of an entry or reference table.

       dcl-proc OKToDelete export;                                           // OK to delete

       dcl-pi OKToDelete ind;                                                // OK to delete
         Default char(1) const options(*nopass);                             // default value
       end-pi;                                                               // OK to delete

       if not %open(StdXrefIOP);                                             // if not already open
         open StdXrefIOP;                                                    // open display file
       endif;                                                                // if not already open

       if %parms >= 1 and Default = 'Y';                                     // if default is yes
         w1okflag = Default;                                                 // force it to window
       else;                                                                 // any other scenario
         w1okflag = 'N';                                                     // assume default is no
       endif;                                                                // if default is yes

       exfmt oktodeltw1;                                                     // pop window
       close StdXrefIOP;                                                     // close display file

       return (w1okflag = 'Y');                                              // true if user says Y

       end-proc;                                                             // OK to delete

      **********************************************************************************************
      *
      *  Checks to see if a combination of specified arguments is valid for a specified
      *  reference table.

       dcl-proc ValidXref export;                                            // valid xref entry

       dcl-pi ValidXref ind;                                                 // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
         DateArg  like(StdXrefI.DateArg)  const options(*nopass);            // date argument
       end-pi;                                                               // valid xref entry

       dcl-s ValidXrefX packed(1);                                           // valid xref found
       dcl-s DateArgX   like(StdXrefI.DateArg);                              // date argument

       if %parms >= 4;                                                       // if date arg passed
         DateArgX = DateArg;                                                 // use its value
       endif;                                                                // if date arg passed

       exec sql select 1 into :ValidXrefX from StdXref
         where RefTable = :RefTable
           and NumArg   = :NumArg
           and CharArg  = :CharArg
           and DateArg  = :DateArgX
           and CharArg <> :Marker;

       return (ValidXrefX > 0);                                              // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Checks to see if a numeric argument is valid for a specified reference table.

       dcl-proc ValidXrefN export;                                           // valid xref entry

       dcl-pi ValidXrefN ind;                                                // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
       end-pi;                                                               // valid xref entry

       return ValidXref(RefTable : NumArg : *blanks : LowDate);              // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Checks to see if a character argument is valid for a specified reference table.

       dcl-proc ValidXrefC export;                                           // valid xref entry

       dcl-pi ValidXrefC ind;                                                // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
       end-pi;                                                               // valid xref entry

       return ValidXref(RefTable : 0 : CharArg : LowDate);                   // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Checks to see if a date argument is valid for a specified reference table.

       dcl-proc ValidXrefD export;                                           // valid xref entry

       dcl-pi ValidXrefD ind;                                                // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         DateArg  like(StdXrefI.DateArg)  const;                             // date argument
       end-pi;                                                               // valid xref entry

       return ValidXref(RefTable : 0 : *blanks : DateArg);                   // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Checks to see if the combination of a numeric and character argument
      *    is valid for a specified reference table.

       dcl-proc ValidXrefNC export;                                          // valid xref entry

       dcl-pi ValidXrefNC ind;                                               // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
       end-pi;                                                               // valid xref entry

       return ValidXref(RefTable : NumArg : CharArg : LowDate);              // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Checks to see if the combination of a numeric and date argument
      *    is valid for a specified reference table.

       dcl-proc ValidXrefND export;                                          // valid xref entry

       dcl-pi ValidXrefND ind;                                               // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
         DateArg  like(StdXrefI.DateArg)  const;                             // date argument
       end-pi;                                                               // valid xref entry

       return ValidXref(RefTable : NumArg : *blank : DateArg);               // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Checks to see if the combination of a character and date argument
      *    is valid for a specified reference table.

       dcl-proc ValidXrefCD export;                                          // valid xref entry

       dcl-pi ValidXrefCD ind;                                               // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
         DateArg  like(StdXrefI.DateArg)  const;                             // date argument
       end-pi;                                                               // valid xref entry

       return ValidXref(RefTable : 0 : CharArg : DateArg);                   // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Instantiates a new cross reference table if it does not exist already.

       dcl-proc putXrefTable export;                                         // put xref table hdr

       dcl-pi putXrefTable ind;                                              // put xref table hdr
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         Descrip  like(StdXrefI.CharRes)  const;                             // table description
       end-pi;                                                               // put xref table hdr

       exec sql update stdxref
         set CharRes = :Descrip
           where RefTable = :RefTable
             and CharArg  = :Marker;                                         // update description

       if sqlcod = 100;                                                      // if no match found
         exec sql
           insert into stdxref (RefTable,  NumArg, CharArg,  DateArg,
                                Hidden,    NumRes, CharRes,  DateRes)
                         values(:RefTable, 0,      :Marker,  :LowDate,
                                ' ',       0,      :Descrip, :LowDate);      // insert table header
       endif;                                                                // if no match found

       return (sqlcod = 0);                                                  // true if successful

       end-proc;                                                             // put xref table hdr

      **********************************************************************************************
      *
      *  Instantiates a new cross reference table entry if it does not exist already.

       dcl-proc putXrefEntry export;                                         // put xref table entry

       dcl-pi putXrefEntry ind;                                              // put xref table entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
         DateArg  like(StdXrefI.DateArg)  const;                             // date argument
         NumRes   like(StdXrefI.NumRes)   const;                             // numeric result
         CharRes  like(StdXrefI.CharRes)  const;                             // character result
         DateRes  like(StdXrefI.DateRes)  const;                             // date result
         Hidden   like(StdXrefI.Hidden)   const;                             // hidden from search
       end-pi;                                                               // put xref table entry

       exec sql update stdxref
         set NumRes = :NumRes, CharRes = :CharRes,
             Hidden = :Hidden, DateRes = :DateRes
           where RefTable = :RefTable
             and NumArg   = :NumArg
             and CharArg  = :CharArg;                                        // update table entry

       if sqlcod = 100;                                                      // if no match found
         exec sql insert into stdxref
           (RefTable, NumArg, CharArg, DateArg,
            Hidden,   NumRes, CharRes, DateRes)
             values(:RefTable, :NumArg,  :CharArg, :DateArg,
                    :Hidden,   :NumRes,  :CharRes, :DateRes);                // insert table entry
       endif;                                                                // if no match found

       return (sqlcod = 0);                                                  // true if successful

       end-proc;                                                             // put xref table entry

      **********************************************************************************************
      *
      *  Determines whether a cross reference table uses a numeric argument.

       dcl-proc isNumericArg export;                                         // xref is numeric arg

       dcl-pi isNumericArg ind;                                              // xref is numeric arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
       end-pi;                                                               // xref is numeric arg

       dcl-s CountX packed(3);                                               // count or records

       exec sql select count(*) into :CountX from stdxref
         where RefTable = :RefTable and NumArg > 0;                          // recs with num arg

       return (CountX > 0);                                                  // true if positive

       end-proc;                                                             // xref is numeric arg

      **********************************************************************************************
      *
      *  Determines whether a cross reference table uses a numeric argument.

       dcl-proc isDateArg export;                                            // xref is date arg

       dcl-pi isDateArg ind;                                                 // xref is date arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
       end-pi;                                                               // xref is date arg

       dcl-s CountX packed(3);                                               // count or records

       exec sql select count(*) into :CountX from stdxref
         where RefTable = :RefTable and DateArg > date('0001-01-01');        // recs with date arg

       return (CountX > 0);                                                  // true if positive

       end-proc;                                                             // xref is date arg

      **********************************************************************************************
      *
      *  Search for an argument in a specified reference table.
      *  Note that this function post-dates the addition of date arguments/results.

       dcl-proc FindXrefArg export;                                          // find xref argument

       dcl-pi FindXrefArg like(StdXrefI.CharArg);                            // find xref argument
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         ArgType  like(StdXrefI.Hidden)   const;                             // argument type
         ResType  like(StdXrefI.Hidden)   const;                             // result type shown
       end-pi;                                                               // find xref argument

       dcl-s SelectedArg like(StdXrefI.CharArg);                             // selected argument
       dcl-s ValidateArg like(StdXrefI.CharArg);                             // validate search arg
       dcl-s ValidateRes like(StdXrefI.CharArg);                             // validate search rslt

       dcl-ds *n;                                                            // arg/result types
         Types char(12) inz('CHARDATENUMR');                                 // type abbreviations
         Abbrv char(4)  dim(3) pos(1);                                       // array of abbrev
         Codes char(1)  overlay(Abbrv);                                      // array of codes
       end-ds;                                                               // arg/result types

       open StdXrefIOP;                                                      // open display file

       c3RefTable = RefTable;                                                // reference table
       c3ArgType  = Abbrv(%lookup(ArgType:Codes)) + ' Argument';             // argmnt column title
       c3ResType  = Abbrv(%lookup(ResType:Codes)) + ' Result';               // result column title

       exec sql declare FindXrefArgX1 cursor for
         select case when :ArgType = 'N' then char(NumArg)
                     when :ArgType = 'D' then char(DateArg)
                                         else CharArg end,
                case when :ResType = 'N' then char(NumRes)
                     when :ResType = 'D' then char(DateRes)
                                         else CharRes end
           from StdXref
             where RefTable = :RefTable
               and Hidden  <> 'Y'
               and (:c3Argument = ' ' or
                    :c3ArgType  = 'N' and NumArg  >= decimal(:c3Argument) or
                    :c3ArgType  = 'C' and CharArg >= :c3Argument          or
                    :c3ArgType  = 'D' and char(DateArg, ISO) >= :c3Argument)
               and (:c3Result   = ' ' or
                    :c3ResType  = 'N' and NumRes  >= decimal(:c3Result)   or
                    :c3ResType  = 'C' and CharRes >= :c3Result            or
                    :c3ResType  = 'D' and char(DateRes, ISO) >= :c3Result)
                 order by 1;                                                 // all table entries

       dou Ind.Cancel or SelectedArg > *blanks;                              // until canc or select

         Ind.EnableSFL  = *off;                                              // disable subfile
         Ind.EnableOpt  = *off;                                              // disable option colm
         Ind.ShowNumArg = *off;                                              // hide numeric arg

         write findxrefc3;                                                   // clear subfile
         clear findxrefs3;                                                   // clear all fields
         clear sflrr3;                                                       // SFL record number

         Ind.EnableSFL = *on;                                                // enable subfile

         exec sql open FindXrefArgX1;                                        // open cursor

         exec sql fetch from FindXrefArgX1
           into :s3argument, :s3result;                                      // fetch first entry

         dow sqlcod = 0 and not %eof(StdXrefIOP);                            // while more entries

           if ArgType = 'N' and s3argument = *blanks;                        // if blank numeric arg
             s3argument = '0';                                               // force a zero char
           endif;                                                            // if blank numeric arg

           Ind.EnableOpt  = *on;                                             // enable option colm
           sflrr3 += 1;                                                      // SFL record number

           write findxrefs3;                                                 // write SFL record

           exec sql fetch from FindXrefArgX1
             into :s3argument, :s3result;                                    // fetch next entry

         enddo;                                                              // until no more rows

         exec sql close FindXrefArgX1;                                       // close cursor

         if sflrr3 = *zeros;                                                 // if subfile empty
           s3result = 'NO ENTRIES FOUND';                                    // show relevant text
           sflrr3 = 2;                                                       // SFL record number
           write findxrefs3;                                                 // write SFL record
         endif;                                                              // if subfile empty

         exfmt findxrefc3;                                                   // pop search window

         if not Ind.Cancel;                                                  // if enter pressed

           clear sflrr3;                                                     // SFL record number

           dou %eof(StdXrefIOP) or s3select > *blanks;                       // until end or select
             readc findxrefs3;                                               // read subfile record
           enddo;                                                            // until end or select

           if s3select > *blanks;                                            // if entry selected

             selectedArg = s3argument;                                       // capture selection

           else;                                                             // no entry selected

             monitor;                                                        // validate search args
               if ArgType = 'N';                                             // if numeric argument
                 ValidateArg = %char(%dec(c3Argument:10:0));                 // ensure it's numeric
               elseif ArgType = 'D';                                         // or date argument
                 ValidateArg = %char(%date(c3Argument:*iso));                // ensure it's a date
               endif;                                                        // if numeric argument
             on-error *all;                                                  // on any error
               c3Argument = *blanks;                                         // ignore search arg
             endmon;                                                         // validate search args

             monitor;                                                        // validate search rslt
               if ResType = 'N';                                             // if numeric result
                 ValidateRes = %char(%dec(c3Result:15:5));                   // ensure it's numeric
               elseif ResType = 'D';                                         // or date result
                 ValidateRes = %char(%date(c3Result:*iso));                  // ensure it's a date
               endif;                                                        // if numeric result
             on-error *all;                                                  // on any error
               c3Result = *blanks;                                           // ignore search result
             endmon;                                                         // validate search rslt

           endif;                                                            // if entry selected

         endif;                                                              // if enter pressed

       enddo;                                                                // until canc or select

       close StdXrefIOP;                                                     // close display file
       return selectedArg;                                                   // return selection

       end-proc;                                                             // find xref num arg

      **********************************************************************************************
      *
      *  Search for a numeric argument in a specified reference table.
      *  Note that this function post-dates the addition of date arguments/results.

       dcl-proc FindXrefArgN export;                                         // find xref num arg

       dcl-pi FindXrefArgN like(StdXrefI.NumArg);                            // find xref num arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.NumArg)   const options(*nopass);            // previous value
         ResType  like(StdXrefI.Hidden)   const options(*nopass);            // result type shown
       end-pi;                                                               // find xref num arg

       dcl-s ResTypeX    like(StdXrefI.Hidden);                              // result type shown
       dcl-s SelectedArg like(StdXrefI.CharArg);                             // selected argument

       if %parms >= 3 and (ResType = 'N' or ResType = 'D');                  // if num or date type
         ResTypeX = ResType;                                                 // use the type passed
       else;                                                                 // any other case
         ResTypeX = 'C';                                                     // assume char type
       endif;                                                                // if valid result type

       SelectedArg = FindXrefArg(RefTable : 'N' : ResTypeX);                 // search window

       if %parms >= 2 and SelectedArg = *blanks;                             // if user cancels out
         return PrvValue;                                                    // keep previous value
       else;                                                                 // user made selection
         return %dec(SelectedArg:10:0);                                      // return selected val
       endif;                                                                // if user cancels out

       end-proc;                                                             // find xref num arg

      **********************************************************************************************
      *
      *  Search for a character argument in a specified reference table.
      *  Note that this function post-dates the addition of date arguments/results.

       dcl-proc FindXrefArgC export;                                         // find xref char arg

       dcl-pi FindXrefArgC like(StdXrefI.CharArg);                           // find xref char arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.CharArg)  const options(*nopass);            // previous value
         ResType  like(StdXrefI.Hidden)   const options(*nopass);            // result type shown
       end-pi;                                                               // find xref char arg

       dcl-s ResTypeX    like(StdXrefI.Hidden);                              // result type shown
       dcl-s SelectedArg like(StdXrefI.CharArg);                             // selected argument

       if %parms >= 3 and (ResType = 'N' or ResType = 'D');                  // if num or date type
         ResTypeX = ResType;                                                 // use the type passed
       else;                                                                 // any other case
         ResTypeX = 'C';                                                     // assume char type
       endif;                                                                // if valid result type

       SelectedArg = FindXrefArg(RefTable : 'C' : ResTypeX);                 // search window

       if %parms >= 2 and SelectedArg = *blanks;                             // if user cancels out
         return PrvValue;                                                    // keep previous value
       else;                                                                 // user made selection
         return SelectedArg;                                                 // return selected val
       endif;                                                                // if user cancels out

       end-proc;                                                             // find xref char arg

      **********************************************************************************************
      *
      *  Search for a date argument in a specified reference table.
      *  Note that this function post-dates the addition of date arguments/results.

       dcl-proc FindXrefArgD export;                                         // find xref date arg

       dcl-pi FindXrefArgD like(StdXrefI.DateArg);                           // find xref date arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.DateArg)  const options(*nopass);            // previous value
         ResType  like(StdXrefI.Hidden)   const options(*nopass);            // result type shown
       end-pi;                                                               // find xref date arg

       dcl-s ResTypeX    like(StdXrefI.Hidden);                              // result type shown
       dcl-s SelectedArg like(StdXrefI.CharArg);                             // selected argument

       if %parms >= 3 and (ResType = 'N' or ResType = 'D');                  // if num or date type
         ResTypeX = ResType;                                                 // use the type passed
       else;                                                                 // any other case
         ResTypeX = 'C';                                                     // assume char type
       endif;                                                                // if valid result type

       SelectedArg = FindXrefArg(RefTable : 'D' : ResTypeX);                 // search window

       if %parms >= 2 and SelectedArg = *blanks;                             // if user cancels out
         return PrvValue;                                                    // keep previous value
       else;                                                                 // user made selection
         return %date(SelectedArg : *iso);                                   // return selected val
       endif;                                                                // if user cancels out

       end-proc;                                                             // find xref date arg

      **********************************************************************************************
      *
      *  Prints all entries in a specified reference table.
      *  Note that this function post-dates the addition of date arguments/results.

       dcl-proc PrintXrefTable export;                                       // print xref tables

       dcl-pi PrintXrefTable;                                                // print xref tables
         RefTable like(StdXrefI.RefTable) value options(*nopass);            // reference table
       end-pi;                                                               // print xref tables

       dcl-ds StdXrefH likeds(StdXrefI) inz;                                 // ref table headers
       dcl-ds StdXrefD likeds(StdXrefI) inz;                                 // ref table detail

       dcl-s RefTableX  like(StdXrefI.RefTable);                             // reference table
       dcl-s CharPos    int(5);                                              // character position
       dcl-s LinesReqd  int(5);                                              // print lines required
       dcl-s CharResLen int(5);                                              // char result length
       dcl-s CharPrtLen int(5) inz(%len(p1CharRes));                         // char result prt leng
       dcl-s NArgActive ind;                                                 // numeric arg active
       dcl-s CArgActive ind;                                                 // char arg active
       dcl-s DArgActive ind;                                                 // date arg active
       dcl-s NResActive ind;                                                 // numeric res active
       dcl-s CResActive ind;                                                 // char res active
       dcl-s DResActive ind;                                                 // date res active

       if %parms >= 1 and RefTable > *blanks;                                // if ref table passed
         RefTableX = RefTable;                                               // just one table
       else;                                                                 // no ref table passed
         RefTableX = '*ALL';                                                 // all tables
       endif;                                                                // if ref table passed

       exec sql declare PrintXrefTablesH cursor for
         select * from stdxref
           where (RefTable = :RefTableX or :RefTableX = '*ALL')
             and CharArg = :Marker
               order by RefTable;                                            // ref table headers

       exec sql declare PrintXrefTablesD cursor for
         select * from stdxref
           where RefTable = :StdXrefH.RefTable
             and CharArg <> :Marker
               order by RefTable, NumArg, CharArg, DateArg;                  // ref table detail

       open stdxreflst;                                                      // open print file

       exec sql open PrintXrefTablesH;                                       // open header cursor
       exec sql fetch from PrintXrefTablesH into :StdXrefH;                  // fetch first header

       dow sqlcod = 0;                                                       // while more headers

         exec sql
           select case when CharRes > ' ' then '1' else '0' end
             into :NArgActive from StdXref
               where RefTable = :TableGuide
                 and NumArg   = :StdXrefH.EntityID
                 and CharArg  = 'NUMARG';                                    // is numer arg active

         exec sql
           select case when CharRes > ' ' then '1' else '0' end
             into :CArgActive from StdXref
               where RefTable = :TableGuide
                 and NumArg   = :StdXrefH.EntityID
                 and CharArg  = 'CHARARG';                                   // is char arg active

         exec sql
           select case when CharRes > ' ' then '1' else '0' end
             into :DArgActive from StdXref
               where RefTable = :TableGuide
                 and NumArg   = :StdXrefH.EntityID
                 and CharArg  = 'DATEARG';                                   // is date arg active

         exec sql
           select case when CharRes > ' ' then '1' else '0' end
             into :NResActive from StdXref
               where RefTable = :TableGuide
                 and NumArg   = :StdXrefH.EntityID
                 and CharArg  = 'NUMRES';                                    // is numer res active

         exec sql
           select case when CharRes > ' ' then '1' else '0' end
             into :CResActive from StdXref
               where RefTable = :TableGuide
                 and NumArg   = :StdXrefH.EntityID
                 and CharArg  = 'CHARRES';                                   // is char res active

         exec sql
           select case when CharRes > ' ' then '1' else '0' end
             into :DResActive from StdXref
               where RefTable = :TableGuide
                 and NumArg   = :StdXrefH.EntityID
                 and CharArg  = 'DATERES';                                   // is date res active

         p1UsrPrf = pgmsts.curusr;                                           // current user profile
         p1RefTbl = StdXrefH.RefTable;                                       // ref table name
         p1TblDes = StdXrefH.CharRes;                                        // ref table descriptor

         write Header;                                                       // new page header

         exec sql open PrintXrefTablesD;                                     // open detail cursor
         exec sql fetch from PrintXrefTablesD into :StdXrefD;                // fetch first detail

         dow sqlcod = 0;                                                     // while more detail

           CharResLen = %len(StdXrefD.CharRes);                              // char result length
           LinesReqd  = 4 + %div(CharResLen - 1 : CharPrtLen);               // print lines required

           if (PrintInf.CurrLine + LinesReqd) >= PrintInf.OvflLine;          // if not enough room
             write Header;                                                   // new page header
           endif;                                                            // if not enough room

           if NArgActive;                                                    // if numeric argument
             p1NumArgX = %trim(%editc(StdXrefD.NumArg:'3'));                 // show its value
           endif;                                                            // if numeric argument

           if NResActive;                                                    // if numeric result
             p1NumResX = %trim(%editc(StdXrefD.NumRes:'3'));                 // show its value
           endif;                                                            // if numeric result

           write NumbDetail;                                                 // numeric detail
           clear NumbDetail;                                                 // clear numeric values

           if CArgActive;                                                    // if char argument
             p1CharArg = StdXrefD.CharArg;                                   // show its value
           endif;                                                            // if char argument

           if CResActive;                                                    // if char result
             p1CharRes = StdXrefD.CharRes;                                   // show its value
           endif;                                                            // if char result

           write CharDetail;                                                 // character detail
           clear CharDetail;                                                 // clear char values

           if CResActive and CharResLen > CharPrtLen;                        // if char res overflow

             CharPos = 1 + CharPrtLen;                                       // overflow position

             dow CharPos <= CharResLen
                   and %subst(StdXrefD.CharRes : CharPos) > ' ';             // while overflow text
               p1CharRes = %subst(StdXrefD.CharRes : CharPos);               // portion of result
               CharPos  += CharPrtLen;                                       // overflow position
               write CharOvrFlw;                                             // char res overflow
             enddo;                                                          // while overflow text

           endif;                                                            // if char res overflow

           if DArgActive;                                                    // if date argument
             p1DatArgX = %char(StdXrefD.DateArg : *iso);                     // show its value
           endif;                                                            // if date argument

           if DResActive;                                                    // if date result
             p1DatResX = %char(StdXrefD.DateRes : *iso);                     // show its value
           endif;                                                            // if date result

           p1Hidden  = StdXrefD.Hidden;                                      // hidden flag

           write DateDetail;                                                 // date detail
           clear DateDetail;                                                 // clear date values
           write Separator;                                                  // entry separator line

           exec sql fetch from PrintXrefTablesD into :StdXrefD;              // fetch next detail

         enddo;                                                              // while more detail

         exec sql close PrintXrefTablesD;                                    // close detail cursor
         exec sql fetch from PrintXrefTablesH into :StdXrefH;                // fetch next header

       enddo;                                                                // while more headers

       exec sql close PrintXrefTablesH;                                      // close header cursor

       close stdxreflst;                                                     // close print file

       end-proc;                                                             // print xref tables

      **********************************************************************************************
      *
      *  Implies the IBM i user profile number for the specified user ID.

       dcl-proc UserNumber export;                                           // user profile number

       dcl-pi UserNumber int(20);                                            // user profile number
         UserID char(10) const;                                              // user ID
       end-pi;                                                               // user profile number

       dcl-s UserNumberX int(20);                                            // user profile number

       exec sql
         select ifnull(USER_ID_NUMBER, 0) into :UserNumberX
           from USER_INFO
             where AUTHORIZATION_NAME = :UserID;                             // retrieve user number

       return UserNumberX;                                                   // return user number

       end-proc;                                                             // user profile number

      **********************************************************************************************
      *
      *  Implies whether the specified user is a super administrator.

       dcl-proc isSuperAdmin export;                                         // user is super admin

       dcl-pi isSuperAdmin ind;                                              // user is super admin
         UserProfile char(10) const options(*nopass);                        // user profile
       end-pi;                                                               // user is super admin

       dcl-s UserProfileX char(10);                                          // user profile

       if %parms >= 1;                                                       // if profile passed
         UserProfileX = UserProfile;                                         // use it
       else;                                                                 // no profile passed
         UserProfileX = pgmsts.curusr;                                       // use current profile
       endif;                                                                // if profile passed

       return ValidXrefC(SuperAdmin : UserProfileX);                         // true if super admin

       end-proc;                                                             // user is super admin

      **********************************************************************************************
      *
      *  Implies whether the specified user is an administrator for the specified table.
      *  Applies only if the table has at least one administrator, otherwise the table
      *    can be maintained by any user.

       dcl-proc isTableAdmin export;                                         // user is table admin

       dcl-pi isTableAdmin ind;                                              // user is table admin
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         UserProfile char(10) const options(*nopass);                        // user profile
       end-pi;                                                               // user is table admin

       dcl-s UserProfileX char(10);                                          // user profile
       dcl-s UserNumberX int(20);                                            // user number
       dcl-s CountX packed(3);                                               // count of records

       exec sql select count(*) into :CountX from StdXref
         where RefTable = :TableAdmin and CharArg = :RefTable;               // num of table admins

       if CountX = 0;                                                        // if table not secured
         return *on;                                                         // anyone can maintain
       endif;                                                                // if table not secured

       if %parms >= 2;                                                       // if profile passed
         UserProfileX = UserProfile;                                         // use it
       else;                                                                 // no profile passed
         UserProfileX = pgmsts.curusr;                                       // use current profile
       endif;                                                                // if profile passed

       if isSuperAdmin(UserProfileX);                                        // if super admin user
         return *on;                                                         // user has all rights
       endif;                                                                // if super admin user

       UserNumberX = UserNumber(UserProfileX);                               // user profile number

       return ValidXrefNC(TableAdmin : UserNumberX : RefTable);              // true if table admin

       end-proc;                                                             // user is super admin

      **********************************************************************************************
      *
      *  Implies the unique entity ID of a reference table header.

       dcl-proc getTableID export;                                           // get table entity ID

       dcl-pi getTableID like(StdXrefI.EntityID);                            // get table entity ID
         RefTable like(StdXrefI.RefTable) const;                             // reference table
       end-pi;                                                               // get table entity ID

       dcl-s EntityIDx like(StdXrefI.EntityID);                              // table entity ID

       exec sql select EntityID into :EntityIDx from StdXref
         where RefTable = :RefTable
           and CharArg  = :Marker;                                           // ID of table header

       return EntityIDx;                                                     // return entity ID

       end-proc;                                                             // get table entity ID

      **********************************************************************************************
      *
      *  Implies the number of entries in the specified reference table.

       dcl-proc NumberOfEntries export;                                      // number of entries

       dcl-pi NumberOfEntries int(5);                                        // number of entries
         RefTable like(StdXrefI.RefTable) const;                             // reference table
       end-pi;                                                               // number of entries

       dcl-s CountX int(5);                                                  // record count

       exec sql
         select ifnull(count(*), 0) into :CountX from StdXref
           where RefTable = :RefTable
             and CharArg <> :Marker;                                         // exclude table header

       return CountX;                                                        // return record count

       end-proc;                                                             // number of entries

      **********************************************************************************************
