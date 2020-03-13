      **********************************************************************************************
      *                                                                                            *
      *  STANDARD CROSS REFERENCE MAINTENANCE (CURRENT)                                            *
      *                                                                                            *
      *  Copyright (C) 2006, 2020  Christopher F. Burns Sr.                                        *
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

      /copy qcpysrc,stdhpgm                                                  // std control specs
      /copy qcpysrc,stdxrefiop                                               // std xref I/O procs
      /copy qcpysrc,stdpgmsts                                                // std prog status DS

       dcl-f stdxrefmn2 workstn sfile(stdxrefs1:sflrr1)
                                sfile(stdxrefs2:sflrr2);                     // maintenance screens

       dcl-pr Listing extpgm('STDXREFC');                                    // hardcopy listing
         RefTable like(s1RefTbl) const;                                      // reference table
       end-pr;                                                               // hardcopy listing

       dcl-pi *n;                                                            // entry parameters
         RefTable like(s1RefTbl) options(*nopass);                           // reference table
       end-pi;                                                               // entry parameters

       dcl-ds Ind based(iptr) qualified;                                     // screen indicators
         Exit       ind      pos(03);                                        // f3 to exit
         Create     ind      pos(06);                                        // f6 to create
         Cancel     ind      pos(12);                                        // f12 to cancel
         Print      ind      pos(21);                                        // f21 to print
         DeleteX    ind      pos(23);                                        // f23 to delete
         EnableSFL1 ind      pos(31);                                        // enable SFL #1
         EnableOpt1 ind      pos(34);                                        // enable SFL #1 opts
         EnableTabl ind      pos(36);                                        // enable table name
         EnableDesc ind      pos(37);                                        // enable table desc
         EnableSFL2 ind      pos(41);                                        // enable SFL #2
         EnableOpt2 ind      pos(44);                                        // enable SFL #2 opts
         EnableArgs ind      pos(46);                                        // enable arguments
         EnableRslt ind      pos(47);                                        // enable results
         TableLevel char(10) pos(60);                                        // table level attrib
         TableExist ind      pos(67);                                        // table already exists
         NamDesReqd ind      pos(69);                                        // name & desc required
         EntryLevel char(10) pos(70);                                        // entry level attrib
         InvCharArg ind      pos(76);                                        // invalid char argmt
         EntryExist ind      pos(77);                                        // entry already exists
       end-ds;                                                               // screen indicators

       dcl-s iptr pointer inz(%addr(*in));                                   // align with indara
       dcl-s sflrr1 int(5);                                                  // sfl #1 record number
       dcl-s sflrr2 int(5);                                                  // sfl #2 record number
       dcl-s errors ind;                                                     // general errors flag


      **********************************************************************************************

       exec sql declare stdxrefx1 cursor for
         select reftable, charres, entityid
           from stdxref
             where chararg   = :Marker
               and reftable >= :c1PosnTo
                 order by 1;                                                 // table headers sql

       exec sql declare stdxrefx2 cursor for
         select numarg, chararg, datearg,
                numres, charres, dateres, hidden,  entityid
           from stdxref
             where reftable = :c2RefTbl
               and chararg <> :Marker
                 order by 1, 2, 3;                                           // table entries sql

       // if a reference table name was passed, go directly to entries

       if %parms > 0 and RefTable <> '*ALL';                                 // if ref table passed

         s1RefTbl = RefTable;                                                // reference table

         exec sql select ifnull(charres, ' ') into :s1TblDes from stdxref
           where reftable = :RefTable
             and numarg   = 0
             and chararg  = :Marker;                                         // ref table descriptor

         dou Ind.Exit or Ind.Cancel;                                         // until exit or cancel

           ShowEntries();                                                    // show table entries

           if Ind.Create;                                                    // if create entry
             EditEntries();                                                  // edit window
           elseif not Ind.Cancel;                                            // or enter pressed
             RevwEntries();                                                  // spin through sfl
           endif;                                                            // if create entry

         enddo;                                                              // until exit or canc

       // no reference table name was passed, header and entry maintenance

       else;                                                                 // no ref table passed

         dou Ind.Exit;                                                       // until user exits

           ShowTables();                                                     // show xref tables

           if Ind.Create;                                                    // if create table
             EditTables();                                                   // edit table header
             RevwTables();                                                   // review table
           elseif Ind.Print;                                                 // or print all tables
             w3RefTbl = '*ALL';                                              // ref table name
             PrintXrefTable(w3RefTbl);                                       // print all tables
             exfmt stdxrefw3;                                                // confirmation window
           elseif not Ind.Exit;                                              // or update table
             RevwTables();                                                   // review table
           endif;                                                            // if create table

         enddo;                                                              // until user exits

       endif;                                                                // if ref table passed

       *inlr = *on;                                                          // end of program

      **********************************************************************************************

       dcl-proc ShowTables;                                                  // show table headers

       clear Ind.EnableSFL1;                                                 // disable sfl #1
       clear Ind.EnableOpt1;                                                 // disable sfl #1 opts
       clear sflrr1;                                                         // sfl record number
       clear stdxrefs1;                                                      // clear all fields
       write stdxrefc1;                                                      // clear subfile

       c1PgmNam = pgmsts.pgmnam;                                             // program name
       c1UsrPrf = pgmsts.usrprf;                                             // user profile

       Ind.EnableSFL1 = *on;                                                 // enable sfl #1

       exec sql open stdxrefx1;                                              // open sql cursor
       exec sql fetch from stdxrefx1
         into :s1RefTbl, :s1TblDes, :s1EntityID;                             // fetch first header

       dow sqlcod = 0;                                                       // while more headers
         sflrr1 += 1;                                                        // sfl record number
         Ind.EnableOpt1 = *on;                                               // enable sfl #1 opts
         write stdxrefs1;                                                    // write subfile recd
         exec sql fetch from stdxrefx1
           into :s1RefTbl, :s1TblDes, :s1EntityID;                           // fetch next header
       enddo;                                                                // while more headers

       exec sql close stdxrefx1;                                             // close sql cursor

       if sflrr1 = 0;                                                        // if subfile empty
         sflrr1 = 2;                                                         // sfl record number
         s1TblDes = 'NO TABLES DEFINED';                                     // no tables message
         write stdxrefs1;                                                    // write subfile recd
       endif;                                                                // if subfile empty

       write stdxrefk1;                                                      // show function keys
       exfmt stdxrefc1;                                                      // display subfile

       end-proc;                                                             // show table headers

      **********************************************************************************************

       dcl-proc RevwTables;                                                  // review tables

       clear sflrr1;                                                         // sfl record number

       dou %eof(stdxrefmn2);                                                 // until end of sfl

         readc stdxrefs1;                                                    // read next entry

         if %eof(stdxrefmn2);                                                // if end of subfile

           // do nothing

         elseif s1Option = 'P';                                              // or print table

           w3RefTbl = s1RefTbl;                                              // ref table name
           PrintXrefTable(w3RefTbl);                                         // print listing
           exfmt stdxrefw3;                                                  // confirmation window

         elseif s1Option = 'T';                                              // or edit table header

           EditTables();                                                     // edit selected table

         elseif s1Option = 'X';                                              // or entry selected

           dou Ind.Exit or Ind.Cancel;                                       // until exit or cancel

             ShowEntries();                                                  // show table entries

             if Ind.Create;                                                  // if create entry
               EditEntries();                                                // edit window
             elseif not Ind.Cancel;                                          // or enter pressed
               RevwEntries();                                                // spin through sfl
             endif;                                                          // if create entry

           enddo;                                                            // until exit or cancel
         endif;                                                              // if entry selected
       enddo;                                                                // until end of sfl

       end-proc;                                                             // review tables

      **********************************************************************************************

       dcl-proc EditTables;                                                  // edit table headers

       dcl-s TableCount int(5);                                              // table entry count

       clear stdxrefw1;                                                      // clear all fields
       clear errors;                                                         // clear error flag

       if Ind.Create;                                                        // if creating entry
         Ind.EnableTabl = *on;                                               // enable table name
         Ind.EnableDesc = *on;                                               // enable description
         w1EntityID = 0;                                                     // no entity ID
       else;                                                                 // updating entry
         Ind.EnableDesc = *on;                                               // enable description
         w1RefTbl   = s1RefTbl;                                              // character argument
         w1TblDes   = s1TblDes;                                              // character result
         w1EntityID = s1EntityID;                                            // entity ID
       endif;                                                                // if creating entry

       dou Ind.Cancel or Ind.DeleteX or not errors;                          // until canc or no err

         exfmt stdxrefw1;                                                    // maintenance window

         if Ind.DeleteX and OKToDelete();                                    // if delete

           if Ind.EnableTabl;                                                // if create mode
             Ind.Cancel = *on;                                               // same as cancel
           else;                                                             // honestly deleting
             exec sql delete from stdxref
               where reftable = :w1RefTbl;                                   // delete entire table
           endif;                                                            // if create mode

         elseif Ind.Cancel;                                                  // or cancel

         else;

           clear TableCount;                                                 // table entry count

           exec sql select count(*) into :TableCount from stdxref
             where reftable = :w1RefTbl
               and chararg  = :Marker;                                       // see if exists

           Ind.NamDesReqd = (w1RefTbl = *blanks or w1TblDes = *blanks);      // name and dsc missing
           Ind.TableExist = (Ind.EnableTabl and TableCount > 0);             // already exists
           errors         = (Ind.TableLevel <> *zeros);                      // general errors flag

           if not errors;                                                    // if no errors

             if TableCount > 0;                                              // if exists
               exec sql update stdxref
                 set charres = :w1TblDes
                   where reftable = :w1RefTbl
                     and numarg   = 0
                     and chararg  = :Marker;                                 // see if exists
             else;                                                           // does not exist
               putXrefTable(w1RefTbl : w1TblDes);                            // insert new header
             endif;                                                          // if exists

           endif;                                                            // if no errors
         endif;                                                              // if delete
       enddo;                                                                // until canc or no err

       clear Ind.EnableTabl;                                                 // disable table info

       end-proc;                                                             // edit table headers

      **********************************************************************************************

       dcl-proc ShowEntries;                                                 // show table entries

       clear Ind.EnableSFL2;                                                 // sfl non display
       clear Ind.EnableOpt2;                                                 // disable sfl option
       clear sflrr2;                                                         // sfl record number
       clear stdxrefs2;                                                      // clear all fields
       write stdxrefc2;                                                      // clear subfile

       Ind.EnableSFL2 = *on;                                                 // sfl display mode
       c2RefTbl  = s1RefTbl;                                                 // reference table
       c2TblDes  = s1TblDes;                                                 // table description
       c2PgmNam  = pgmsts.pgmnam;                                            // program name
       c2UsrPrf  = pgmsts.usrprf;                                            // user profile
       c2RcdCurs = 1;                                                        // sfl cursor position

       exec sql open stdxrefx2;                                              // open sql cursor
       exec sql fetch from stdxrefx2
         into :s2NumArg, :s2CharArg, :s2DateArg,
              :s2NumRes, :s2CharRes, :s2DateRes,
              :s2Hidden, :s2EntityID;                                        // fetch first entry

       dow sqlcod = 0;                                                       // while more entries

         sflrr2 += 1;                                                        // sfl record number

         if s2DateArg > *loval;                                              // if date argument
           s2DatArgX = %char(s2DateArg:*iso);                                // show actual date
         else;                                                               // no date argument
           s2DatArgX = *blanks;                                              // show blanks instead
         endif;                                                              // if date argument

         if s2DateRes > *loval;                                              // if date result
           s2DatResX = %char(s2DateRes:*iso);                                // show actual date
         else;                                                               // no date result
           s2DatResX = *blanks;                                              // show blanks instead
         endif;                                                              // if date result

         if s2CharArg = *blanks and s2DatArgX = *blanks;                     // if numeric arg only
           s2NumArgX = %trim(%editc(s2NumArg:'3'));                          // align numeric arg
         else;                                                               // other arguments
           s2NumArgX = %trim(%editc(s2NumArg:'4'));                          // align numeric arg
         endif;                                                              // if numeric arg only

         if s2CharRes = *blanks and s2DatResX = *blanks;                     // if numeric res only
           s2NumResX = %trim(%editc(s2NumRes:'1'));                          // align numeric res
         else;                                                               // other results
           s2NumResX = %trim(%editc(s2NumRes:'2'));                          // align numeric res
         endif;                                                              // if numeric res only

         Ind.EnableOpt2 = *on;                                               // enable sfl option

         if c2ArgPosn > *blanks and c2RcdCurs = 1;                           // if argument posn to

           if s2NumArgX > *blanks and s2NumArgX >= c2ArgPosn
           or s2CharArg > *blanks and s2CharArg >= c2ArgPosn
           or s2DatArgX > *blanks and s2DatArgX >= c2ArgPosn;                // if matching argument
             c2RcdCurs = sflrr2;                                             // set cursor position
           endif;                                                            // if matching argument

         elseif c2ResPosn > *blanks and c2RcdCurs = 1;                       // or result posn to

           if s2NumResX > *blanks and s2NumResX >= c2ResPosn
           or s2CharRes > *blanks and s2CharRes >= c2ResPosn
           or s2DatResX > *blanks and s2DatResX >= c2ResPosn;                // if matching result
             c2RcdCurs = sflrr2;                                             // set cursor position
           endif;                                                            // if matching result

         endif;                                                              // if argument posn to

         write stdxrefs2;                                                    // write subfile recd

         exec sql fetch from stdxrefx2
           into :s2NumArg, :s2CharArg, :s2DateArg,
                :s2NumRes, :s2CharRes, :s2DateRes,
                :s2Hidden, :s2EntityID;                                      // fetch first entry

       enddo;                                                                // while more entries

       exec sql close stdxrefx2;                                             // close sql cursor

       if sflrr2 = 0;                                                        // if subfile empty
         sflrr2 = 1;                                                         // sfl record number
         s2CharRes = 'NO ENTRIES DEFINED';                                   // no entries message
         write stdxrefs2;                                                    // write subfile recd
       endif;                                                                // if subfile empty

       write stdxrefk2;                                                      // show function keys
       exfmt stdxrefc2;                                                      // display subfile

       end-proc;                                                             // show table entries

      **********************************************************************************************

       dcl-proc RevwEntries;                                                 // review entries

       if Ind.Print;                                                         // if print

         w3RefTbl = c2RefTbl;                                                // ref table name
         PrintXrefTable(w3RefTbl);                                           // print listing
         exfmt stdxrefw3;                                                    // confirmation window

       elseif Ind.DeleteX and OKToDelete();                                  // or delete table

         exec sql delete from stdxref
           where reftable = :w1RefTbl;                                       // delete entire table

         Ind.Cancel = *on;                                                   // back to table list

       else;                                                                 // or enter pressed

         clear sflrr2;                                                       // sfl record number

         dou %eof(stdxrefmn2);                                               // until end of sfl

           readc stdxrefs2;                                                  // read next entry

           if s2Option > *blanks and not %eof(stdxrefmn2);                   // if entry selected
             EditEntries();                                                  // edit selected entry
           endif;                                                            // if entry selected

         enddo;                                                              // until end of sfl
       endif;                                                                // if print

       end-proc;                                                             // review entries

      **********************************************************************************************

       dcl-proc EditEntries;                                                 // edit table entries

       dcl-s EntryCount int(5);                                              // table entry count

       clear stdxrefw2;                                                      // clear all fields
       clear errors;

       if Ind.Create;                                                        // if creating entry
         Ind.EnableArgs = *on;                                               // enable arguments
         Ind.EnableRslt = *on;                                               // enable results
         w2Hidden   = 'N';                                                   // hidden from search
         w2EntityID = 0;                                                     // no entity ID
       else;                                                                 // updating entry
         Ind.EnableRslt = *on;                                               // enable results
         w2NumArg   = s2NumArg;                                              // numeric argument
         w2CharArg  = s2CharArg;                                             // character argument
         w2DateArg  = s2DateArg;                                             // character argument
         w2NumRes   = s2NumRes;                                              // numeric result
         w2CharRes  = s2CharRes;                                             // character result
         w2DateRes  = s2DateRes;                                             // character result
         w2Hidden   = s2Hidden;                                              // hidden from search
         w2EntityID = s2EntityID;                                            // entity ID
       endif;                                                                // if creating entry

       dou Ind.Cancel or Ind.DeleteX or not errors;                          // until canc or no err

         exfmt stdxrefw2;                                                    // maintenance window

         if Ind.DeleteX and OKToDelete();                                    // if delete

           if Ind.EnableArgs;                                                // if create mode
             Ind.Cancel = *on;                                               // same as cancel
           else;                                                             // honestly deleting
             exec sql delete from stdxref where entityid = :w2EntityID;      // delete this entry
           endif;                                                            // if create mode

         elseif Ind.Cancel;                                                  // or cancel

         else;                                                               // or enter pressed

           clear EntryCount;                                                 // table entry count

           exec sql select count(*) into :EntryCount from stdxref
             where reftable = :c2RefTbl
               and numarg   = :w2NumArg
               and chararg  = :w2CharArg
               and datearg  = :w2DateArg
               and chararg <> :Marker;                                       // see if entry exists

           Ind.EntryExist = (Ind.EnableArgs and EntryCount > 0);             // entry already exists
           Ind.InvCharArg = (w2CharArg = Marker);                            // invalid char argmt
           errors         = (Ind.EntryLevel <> *zeros);                      // general errors flag

           if not errors;                                                    // if no errors

             if w2EntityID > 0;                                              // if updating entry
               exec sql update stdxref
                 set numres  = :w2NumRes,
                     charres = trim(:w2CharRes),
                     dateres = :w2DateRes,
                     hidden  = :w2Hidden
                   where entityID = :w2EntityID;                             // update this entry
             else;                                                           // adding new entry
               exec sql insert into stdxref
                 (reftable, numarg, chararg, datearg,
                            numres, charres, dateres, hidden)
                   values(trim(:c2RefTbl),
                          :w2NumArg, trim(:w2CharArg), :w2DateArg,
                          :w2NumRes, trim(:w2CharRes), :w2DateRes,
                          :w2Hidden);                                        // insert new entry
             endif;                                                          // if updating entry

           endif;                                                            // if no errors
         endif;                                                              // if delete
       enddo;                                                                // until canc or no err

       clear Ind.Cancel;                                                     // reset f12 key
       clear Ind.EnableArgs;                                                 // reset create mode

       end-proc;                                                             // edit table entries

