      **********************************************************************************************
      *                                                                                            *
      *  STANDARD CROSS REFERENCE I/O PROCEDURES                                                   *
      *                                                                                            *
      *  Copyright (C) 2006, 2018  Christopher F. Burns Sr.                                        *
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

       dcl-f StdXrefIOP workstn usropn sfile(findxrefs1:sflrr1)
                                       sfile(findxrefs2:sflrr2);             // search windows

       dcl-ds Ind based(iptr) qualified;                                     // screen indicators
         Exit       ind pos(03);                                             // f3 to exit
         Cancel     ind pos(12);                                             // f12 to cancel
         EnableSFL  ind pos(31);                                             // enable subfile
         EnableOpt  ind pos(41);                                             // enable option colm
         ShowNumArg ind pos(42);                                             // show numeric arg
       end-ds;                                                               // screen indicators

       dcl-s sflrr1 int(5);                                                  // SFL #1 record number
       dcl-s sflrr2 int(5);                                                  // SFL #2 record number
       dcl-s iptr pointer inz(%addr(*in));                                   // pointer to indicator

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, using both arguments.

       dcl-proc XrefNum export;                                              // xref with num result

       dcl-pi XrefNum like(StdXref.numres);                                  // xref with num result
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
         CharArg  like(StdXref.chararg)  const;                              // character argument
       end-pi;                                                               // xref with num result

       dcl-s NumResX like(StdXref.numres);                                   // numeric result

       exec sql
         select ifnull(numres, 0) into :NumResX from StdXref
           where reftable = :RefTable
             and numarg   = :Numarg
             and chararg  = :CharArg
             and chararg <> :Marker
               fetch first row only;                                         // get matching entry

       return NumResX;                                                       // retn numeric result

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, using numeric argument only.

       dcl-proc XrefNumN export;                                             // xref with num result

       dcl-pi XrefNumN like(StdXref.numres);                                 // xref with num result
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
       end-pi;                                                               // xref with num result

       return XrefNum(RefTable : NumArg : *blanks);                          // assume no char arg

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, using character argument only.

       dcl-proc XrefNumC export;                                             // xref with num result

       dcl-pi XrefNumC like(StdXref.numres);                                 // xref with num result
         RefTable like(StdXref.reftable) const;                              // reference table name
         CharArg  like(StdXref.chararg)  const;                              // character argument
       end-pi;                                                               // xref with num result

       return XrefNum(RefTable : 0 : CharArg);                               // assume no num arg

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table.

       dcl-proc XrefChar export;                                             // xref with chr result

       dcl-pi XrefChar like(StdXref.charres);                                // xref with chr result
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
         CharArg  like(StdXref.chararg)  const;                              // character argument
       end-pi;                                                               // xref with chr result

       dcl-s CharResX like(StdXref.charres);                                 // character result

       exec sql
         select ifnull(charres, ' ') into :CharResX from StdXref
           where reftable = :RefTable
             and numarg   = :NumArg
             and chararg  = :CharArg
             and chararg <> :Marker
               fetch first row only;                                         // get matching entry

       return CharResX;                                                      // retn char result

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table, using numeric argument only.

       dcl-proc XrefCharN export;                                            // xref with chr result

       dcl-pi XrefCharN like(StdXref.charres);                               // xref with chr result
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
       end-pi;                                                               // xref with chr result

       return XrefChar(RefTable : NumArg : *blanks);                         // assume no chr arg

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table, using char. argument only.

       dcl-proc XrefCharC export;                                            // xref with chr result

       dcl-pi XrefCharC like(StdXref.charres);                               // xref with chr result
         RefTable like(StdXref.reftable) const;                              // reference table name
         CharArg  like(StdXref.chararg)  const;                              // character argument
       end-pi;                                                               // xref with chr result

       return XrefChar(RefTable : 0 : CharArg);                              // assume no num arg

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Search for a numeric argument in a specified reference table.

       dcl-proc FindXrefNum export;                                          // find xref num arg

       dcl-pi FindXrefNum like(StdXref.numarg);                              // find xref num arg
         RefTable like(StdXref.reftable) const;                              // reference table
         PrvValue like(StdXref.numarg)   const options(*nopass);             // previous value
       end-pi;                                                               // find xref num arg

       dcl-s SelectedArg like(StdXref.numarg);                               // selected num arg

       open StdXrefIOP;                                                      // open display file

       c2reftable = RefTable;                                                // reference table

       exec sql declare FindXrefNumX1 cursor for
         select reftable, numarg, charres from StdXref
           where  reftable = :RefTable
             and  numarg  >= :c2numarg
             and  chararg <> :Marker
             and  hidden  <> 'Y'
               order by 2;                                                   // ordering by arg

       exec sql declare FindXrefNumX2 cursor for
         select reftable, numarg, charres from StdXref
           where reftable  = :reftable
             and charres  >= :c2charres
             and chararg  <> :Marker
             and  hidden  <> 'Y'
               order by 3;                                                   // ordering by desc

       dou Ind.Cancel or SelectedArg > 0;                                    // until canc or select

         Ind.EnableSFL  = *off;                                              // disable subfile
         Ind.EnableOpt  = *off;                                              // disable option colm
         Ind.ShowNumArg = *off;                                              // hide numeric arg

         write findxrefc2;                                                   // clear subfile
         clear findxrefs2;                                                   // clear all fields
         clear sflrr2;                                                       // SFL record number

         Ind.EnableSFL = *on;                                                // enable subfile

         if c2charres > *blanks;                                             // if search on result
           exec sql open findxrefnumx2;                                      // open its cursor
         else;                                                               // search on argument
           exec sql open findxrefnumx1;                                      // open its cursor
         endif;                                                              // if search on result

         dou sqlcod <> 0 or %eof(StdXrefIOP);                                // until no more rows

           if c2charres > *blanks;                                           // if search on result
             exec sql fetch from findxrefnumx2
               into :s2reftable, :s2numarg, :s2charres;                      // fetch table entry
           else;                                                             // search on arg
             exec sql fetch from findxrefnumx1
               into :s2reftable, :s2numarg, :s2charres;                      // fetch table entry
           endif;                                                            // if search on result

           if sqlcod = *zeros;                                               // if successful fetch
             Ind.EnableOpt  = *on;                                           // enable option colm
             Ind.ShowNumArg = *on;                                           // show numeric arg
             sflrr2 += 1;                                                    // SFL record number
             write findxrefs2;                                               // write SFL record
           endif;                                                            // if successful fetch

         enddo;                                                              // until no more rows

         if c2charres > *blanks;                                             // if search on result
           exec sql close findxrefnumx2;                                     // close its cursor
         else;                                                               // search on argument
           exec sql close findxrefnumx1;                                     // close its cursor
         endif;                                                              // if search on result

         if sflrr2 = *zeros;                                                 // if subfile empty
           s2charres = 'NO ENTRIES FOUND';                                   // show relevant text
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
             selectedArg = s2numarg;                                         // capture selection
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

       dcl-pi FindXrefChar like(StdXref.chararg);                            // find xref char arg
         RefTable like(StdXref.reftable) const;                              // reference table
         PrvValue like(StdXref.chararg)  const options(*nopass);             // previous value
       end-pi;                                                               // find xref char arg

       dcl-s SelectedArg like(StdXref.chararg);                              // selected char arg

       open StdXrefIOP;                                                      // open display file

       c1reftable = reftable;                                                // reference table

       exec sql declare FindXrefCharX1 cursor for
         select reftable, chararg, charres from StdXref
           where  reftable  = :RefTable
             and  chararg  >= :c1chararg
             and  chararg  <> :Marker
             and  hidden   <> 'Y'
               order by 2;                                                   // ordering by arg

       exec sql declare findxrefcharx2 cursor for
         select reftable, chararg, charres from StdXref
           where  reftable  = :reftable
             and  charres  >= :c1charres
             and  chararg  <> :Marker
             and  hidden   <> 'Y'
               order by 3;                                                   // ordering by desc

       dou Ind.Cancel or SelectedArg > *blanks;                              // until canc or select

         Ind.EnableSFL = *off;                                               // disable subfile
         Ind.EnableOpt = *off;                                               // disable option colm

         write findxrefc1;                                                   // clear subfile
         clear findxrefs1;                                                   // clear all fields
         clear sflrr1;                                                       // SFL record number

         Ind.EnableSFL = *on;                                                // enable subfile

         if c1charres > *blanks;                                             // if search on result
           exec sql open findxrefcharx2;                                     // open its cursor
         else;                                                               // search on argument
           exec sql open findxrefcharx1;                                     // open its cursor
         endif;                                                              // if search on result

         dou sqlcod <> *zeros or %eof(StdXrefIOP);                           // until no more rows

           if c1charres > *blanks;                                           // if search on result
             exec sql fetch from findxrefcharx2
               into :s1reftable, :s1chararg, :s1charres;                     // fetch table entry
           else;                                                             // search on arg
             exec sql fetch from findxrefcharx1
               into :s1reftable, :s1chararg, :s1charres;                     // fetch table entry
           endif;                                                            // if search on result

           if sqlcod = *zeros;                                               // if successful fetch
             Ind.EnableOpt = *on;                                            // enable option colm
             sflrr1 += 1;                                                    // SFL record number
             write findxrefs1;                                               // write SFL record
           endif;                                                            // if successful fetch

         enddo;                                                              // until no more rows

         if c1charres > *blanks;                                             // if search on result
           exec sql close findxrefcharx2;                                    // close its cursor
         else;                                                               // search on argument
           exec sql close findxrefcharx1;                                    // close its cursor
         endif;                                                              // if search on result

         if sflrr1 = 0;                                                      // if subfile empty
           s1charres = 'NO ENTRIES FOUND';                                   // show relevant text
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
             selectedArg = s1chararg;                                        // capture selection
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
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
         CharArg  like(StdXref.chararg)  const;                              // character argument
       end-pi;                                                               // valid xref entry

       dcl-s ValidXrefX packed(1);                                           // valid xref found

       exec sql select 1 into :ValidXrefX from StdXref
         where reftable = :RefTable
           and numarg   = :NumArg
           and chararg  = :CharArg
           and chararg <> :Marker;

       return (ValidXrefX > 0);                                              // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Checks to see if a numeric argument is valid for a specified reference table.

       dcl-proc ValidXrefN export;                                           // valid xref entry

       dcl-pi ValidXrefN ind;                                                // valid xref entry
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
       end-pi;                                                               // valid xref entry

       return ValidXref(RefTable : NumArg : *blanks);                        // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Checks to see if a character argument is valid for a specified reference table.

       dcl-proc ValidXrefC export;                                           // valid xref entry

       dcl-pi ValidXrefC ind;                                                // valid xref entry
         RefTable like(StdXref.reftable) const;                              // reference table name
         CharArg  like(StdXref.chararg)  const;                              // character argument
       end-pi;                                                               // valid xref entry

       return ValidXref(RefTable : 0 : CharArg);                             // true if match found

       end-proc;                                                             // valid xref entry

      **********************************************************************************************
      *
      *  Instantiates a new cross reference table if it does not exist already.

       dcl-proc putXrefTable export;                                         // put xref table hdr

       dcl-pi putXrefTable ind;                                              // put xref table hdr
         RefTable    like(StdXref.reftable) const;                           // reference table name
         Description like(StdXref.charres)  const;                           // table description
       end-pi;                                                               // put xref table hdr

       exec sql update stdxref
         set charres = :Description
           where reftable = :RefTable
             and chararg  = :Marker;                                         // update description

       if sqlcod = 100;                                                      // if no match found
         exec sql
           insert into stdxref (reftable, chararg, charres)
             values(:RefTable, :Marker, :Description);                       // insert table header
       endif;                                                                // if no match found

       return (sqlcod = 0);                                                  // true if successful

       end-proc;                                                             // put xref table hdr

      **********************************************************************************************
      *
      *  Instantiates a new cross reference table entry if it does not exist already.

       dcl-proc putXrefEntry export;                                         // put xref table entry

       dcl-pi putXrefEntry ind;                                              // put xref table entry
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
         CharArg  like(StdXref.chararg)  const;                              // character argument
         NumRes   like(StdXref.numres)   const;                              // numeric result
         CharRes  like(StdXref.charres)  const;                              // character result
         Hidden   like(StdXref.hidden)   const;                              // hidden from search
       end-pi;                                                               // put xref table entry

       exec sql update stdxref
         set numres = :NumRes, charres = :CharRes, hidden = :Hidden
           where reftable = :RefTable
             and numarg   = :NumArg
             and chararg  = :CharArg;                                        // update table entry

       if sqlcod = 100;                                                      // if no match found
         exec sql insert into stdxref
           (reftable, numarg, chararg, numres, charres, hidden)
             values(:RefTable, :NumArg,  :CharArg,
                    :NumRes,   :CharRes, :Hidden);                           // insert table entry
       endif;                                                                // if no match found

       return (sqlcod = 0);                                                  // true if successful

       end-proc;                                                             // put xref table entry

      **********************************************************************************************
      *
      *  Determines whether a cross reference table uses a numeric argument.

       dcl-proc isNumericArg export;                                         // xref is numeric arg

       dcl-pi isNumericArg ind;                                              // xref is numeric arg
         RefTable like(stdxref.reftable) const;                              // reference table
       end-pi;                                                               // xref is numeric arg

       dcl-s CountX packed(3);                                               // count or records

       exec sql select count(*) into :CountX from stdxref
         where reftable = :RefTable and numarg > 0;                          // recs with num arg

       return (CountX > 0);                                                  // true if positive

       end-proc;                                                             // xref is numeric arg

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, using both arguments,
      *    after incrementing the result by the specified value.  The numeric result column
      *    is updated in the matching entry.

       dcl-proc IncrXrefNum export;                                          // increment xref num

       dcl-f StdXrefL1 keyed usage(*update) rename(StdXref:StdXrefR);        // standard cross ref

       dcl-pi IncrXrefNum like(StdXref.numres);                              // increment xref num
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
         CharArg  like(StdXref.chararg)  const;                              // character argument
         IncrVal  like(StdXref.numres)   const;                              // increment value
       end-pi;                                                               // increment xref num

       dcl-ds StdXrefX likerec(StdXrefR:*all) inz;                           // std cross ref recd

       monitor;                                                              // catch I/O errors
         chain (RefTable : NumArg : CharArg) StdXrefR StdXrefX;              // get matching entry
       on-error *all;                                                        // on any error
         return 0;                                                           // return zero value
       endmon;                                                               // catch I/O errors

       if %found(StdXrefL1);                                                 // if match entry found
         StdXrefX.numres += IncrVal;                                         // increment num result
         update StdXrefR StdXrefX;                                           // update xref entry
         return StdXrefX.numres;                                             // return new result
       else;                                                                 // no match entry found
         return 0;                                                           // return zero value
       endif;                                                                // if match entry found

       end-proc;                                                             // increment xref num

      **********************************************************************************************
