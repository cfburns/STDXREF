      **********************************************************************************************
      *                                                                                            *
      *  STANDARD CROSS REFERENCE APPLICATION FUNCTIONS                                            *
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

      /copy qcpysrc,stdhsrvpgm                                               // std control specs
      /copy qcpysrc,stdxreffnc                                               // std xref app funcs
      /copy qcpysrc,stdxrefiop                                               // std xref I/O funcs
      /copy qcpysrc,stdpgmsts                                                // std prog status DS


      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, using both arguments.

       dcl-proc XrefNum export;                                              // xref with num result

       dcl-pi XrefNum like(StdXrefF.numres);                                 // xref with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with num result

       dcl-s NumResX like(StdXrefF.numres);                                  // numeric result

       exec sql
         select ifnull(numres, 0) into :NumResX from StdXref
           where reftable = :RefTable
             and numarg   = :Numarg
             and chararg  = :CharArg
             and datearg  = :DateArg
             and chararg <> :Marker
               order by entityID
                 fetch first row only;                                       // get matching entry

       return NumResX;                                                       // retn numeric result

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, using numeric argument only.

       dcl-proc XrefNumN export;                                             // xref with num result

       dcl-pi XrefNumN like(StdXrefF.numres);                                // xref with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
       end-pi;                                                               // xref with num result

       return XrefNum(RefTable : NumArg : *blanks : *loval);                 // assume no other args

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, using character argument only.

       dcl-proc XrefNumC export;                                             // xref with num result

       dcl-pi XrefNumC like(StdXrefF.numres);                                // xref with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
       end-pi;                                                               // xref with num result

       return XrefNum(RefTable : 0 : CharArg : *loval);                      // assume no other args

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, using date argument only.

       dcl-proc XrefNumD export;                                             // xref with num result

       dcl-pi XrefNumD like(StdXrefF.numres);                                // xref with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with num result

       return XrefNum(RefTable : 0 : *blanks : DateArg);                     // assume no other args

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table,
      *    using the combination of a numeric and character argument.

       dcl-proc XrefNumNC export;                                            // xref with num result

       dcl-pi XrefNumNC like(StdXrefF.numres);                               // xref with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
       end-pi;                                                               // xref with num result

       return XrefNum(RefTable : NumArg : CharArg : *loval);                 // assume no date arg

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table,
      *    using the combination of a numeric and date argument.

       dcl-proc XrefNumND export;                                            // xref with num result

       dcl-pi XrefNumND like(StdXrefF.numres);                               // xref with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with num result

       return XrefNum(RefTable : NumArg : *blank : DateArg);                 // assume no char arg

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table,
      *    using the combination of a character and date argument.

       dcl-proc XrefNumCD export;                                            // xref with num result

       dcl-pi XrefNumCD like(StdXrefF.numres);                               // xref with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with num result

       return XrefNum(RefTable : 0 : CharArg : DateArg);                     // assume no num arg

       end-proc;                                                             // xref with num result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table.

       dcl-proc XrefChar export;                                             // xref with chr result

       dcl-pi XrefChar like(StdXrefF.charres);                               // xref with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with chr result

       dcl-s CharResX like(StdXrefF.charres);                                // character result

       exec sql
         select ifnull(charres, ' ') into :CharResX from StdXref
           where reftable = :RefTable
             and numarg   = :NumArg
             and chararg  = :CharArg
             and datearg  = :DateArg
             and chararg <> :Marker
               order by entityID
                 fetch first row only;                                       // get matching entry

       return CharResX;                                                      // retn char result

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table, using numeric argument only.

       dcl-proc XrefCharN export;                                            // xref with chr result

       dcl-pi XrefCharN like(StdXrefF.charres);                              // xref with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
       end-pi;                                                               // xref with chr result

       return XrefChar(RefTable : NumArg : *blanks : *loval);                // assume no other args

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table, using char. argument only.

       dcl-proc XrefCharC export;                                            // xref with chr result

       dcl-pi XrefCharC like(StdXrefF.charres);                              // xref with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
       end-pi;                                                               // xref with chr result

       return XrefChar(RefTable : 0 : CharArg : *loval);                     // assume no other args

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table, using date argument only.

       dcl-proc XrefCharD export;                                            // xref with chr result

       dcl-pi XrefCharD like(StdXrefF.charres);                              // xref with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with chr result

       return XrefChar(RefTable : 0 : *blanks : DateArg);                    // assume no other args

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table,
      *    using the combination of a numeric and character argument.

       dcl-proc XrefCharNC export;                                           // xref with chr result

       dcl-pi XrefCharNC like(StdXrefF.charres);                             // xref with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
       end-pi;                                                               // xref with chr result

       return XrefChar(RefTable : NumArg : CharArg : *loval);                // assume no date arg

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table,
      *    using the combination of a numeric and date argument.

       dcl-proc XrefCharND export;                                           // xref with chr result

       dcl-pi XrefCharND like(StdXrefF.charres);                             // xref with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with chr result

       return XrefChar(RefTable : NumArg : *blank : DateArg);                // assume no char arg

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table,
      *    using the combination of a character and date argument.

       dcl-proc XrefCharCD export;                                           // xref with chr result

       dcl-pi XrefCharCD like(StdXrefF.charres);                             // xref with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with chr result

       return XrefChar(RefTable : 0 : CharArg : DateArg);                    // assume no num arg

       end-proc;                                                             // xref with chr result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table.

       dcl-proc XrefDate export;                                             // xref with dat result

       dcl-pi XrefDate like(StdXrefF.dateres);                               // xref with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with dat result

       dcl-s DateResX like(StdXrefF.dateres);                                // date result

       exec sql
         select ifnull(dateres, date('0001-01-01')) into :DateResX from StdXref
           where reftable = :RefTable
             and numarg   = :NumArg
             and chararg  = :CharArg
             and datearg  = :DateArg
             and chararg <> :Marker
               order by entityID
                 fetch first row only;                                       // get matching entry

       return DateResX;                                                      // retn date result

       end-proc;                                                             // xref with dat result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table, using numeric argument only.

       dcl-proc XrefDateN export;                                            // xref with dat result

       dcl-pi XrefDateN like(StdXrefF.dateres);                              // xref with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
       end-pi;                                                               // xref with dat result

       return XrefDate(RefTable : NumArg : *blanks : *loval);                // assume no other args

       end-proc;                                                             // xref with dat result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table, using char. argument only.

       dcl-proc XrefDateC export;                                            // xref with dat result

       dcl-pi XrefDateC like(StdXrefF.dateres);                              // xref with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
       end-pi;                                                               // xref with dat result

       return XrefDate(RefTable : 0 : CharArg : *loval);                     // assume no other args

       end-proc;                                                             // xref with dat result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table, using date argument only.

       dcl-proc XrefDateD export;                                            // xref with dat result

       dcl-pi XrefDateD like(StdXrefF.dateres);                              // xref with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with dat result

       return XrefDate(RefTable : 0 : *blanks : DateArg);                    // assume no other args

       end-proc;                                                             // xref with dat result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table,
      *    using the combination of a numeric and character argument.

       dcl-proc XrefDateNC export;                                           // xref with dat result

       dcl-pi XrefDateNC like(StdXrefF.dateres);                             // xref with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
       end-pi;                                                               // xref with dat result

       return XrefDate(RefTable : NumArg : CharArg : *loval);                // assume no date arg

       end-proc;                                                             // xref with dat result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table,
      *    using the combination of a numeric and date argument.

       dcl-proc XrefDateND export;                                           // xref with dat result

       dcl-pi XrefDateND like(StdXrefF.dateres);                             // xref with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with dat result

       return XrefDate(RefTable : NumArg : *blank : DateArg);                // assume no char arg

       end-proc;                                                             // xref with dat result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table,
      *    using the combination of a character and date argument.

       dcl-proc XrefDateCD export;                                           // xref with dat result

       dcl-pi XrefDateCD like(StdXrefF.dateres);                             // xref with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // xref with dat result

       return XrefDate(RefTable : 0 : CharArg : DateArg);                    // assume no num arg

       end-proc;                                                             // xref with dat result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, using both arguments,
      *    after incrementing the result by the specified value.  The numeric result column
      *    is updated in the matching entry.

       dcl-proc IncrXrefNum export;                                          // increment xref num

       dcl-f StdXrefL1 keyed usage(*update) rename(StdXref:StdXrefR);        // standard cross ref

       dcl-pi IncrXrefNum like(StdXrefF.numres);                             // increment xref num
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
         IncrVal  like(StdXrefF.numres)   const;                             // increment value
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
      *
      *  Retrieve a date result from a specified reference table, using all arguments,
      *    after incrementing the result by the specified number of days.  The date
      *    result column is updated in the matching entry.

       dcl-proc IncrXrefDate export;                                         // increment xref date

       dcl-f StdXrefL1 keyed usage(*update) rename(StdXref:StdXrefR);        // standard cross ref

       dcl-pi IncrXrefDate like(StdXrefF.dateres);                           // increment xref date
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
         IncrDays like(StdXrefF.numarg)   const;                             // increment num days
       end-pi;                                                               // increment xref date

       dcl-ds StdXrefX likerec(StdXrefR:*all) inz;                           // std cross ref recd

       monitor;                                                              // catch I/O errors
         chain (RefTable : NumArg : CharArg : DateArg) StdXrefR StdXrefX;    // get matching entry
       on-error *all;                                                        // on any error
         return *loval;                                                      // return low date
       endmon;                                                               // catch I/O errors

       if %found(StdXrefL1);                                                 // if match entry found
         StdXrefX.DateRes += %days(IncrDays);                                // increment dat result
         update StdXrefR StdXrefX;                                           // update xref entry
         return StdXrefX.DateRes;                                            // return new result
       else;                                                                 // no match entry found
         return *loval;                                                      // return low date
       endif;                                                                // if match entry found

       end-proc;                                                             // increment xref date

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, based on a
      *    numeric argument in a stepladder progression.

       dcl-proc XrefNStepN export;                                           // step with num result

       dcl-pi XrefNStepN like(StdXrefF.numres);                              // step with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
       end-pi;                                                               // step with num result

       dcl-s NumArgX like(StdXrefF.numarg);                                  // numeric argument

       exec sql
         select max(numarg) into :NumArgX from StdXref
           where reftable  = :RefTable
             and numarg   <= :Numarg
             and chararg  <> :Marker;                                        // highest step reached

       return XrefNumN(RefTable : NumArgX);                                  // retn numeric result

       end-proc;                                                             // step with num result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table, based on a
      *    numeric argument in a stepladder progression.

       dcl-proc XrefCStepN export;                                           // step with chr result

       dcl-pi XrefCStepN like(StdXrefF.charres);                             // step with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
       end-pi;                                                               // step with chr result

       dcl-s NumArgX like(StdXrefF.numarg);                                  // numeric argument

       exec sql
         select max(numarg) into :NumArgX from StdXref
           where reftable  = :RefTable
             and numarg   <= :Numarg
             and chararg  <> :Marker;                                        // highest step reached

       return XrefCharN(RefTable : NumArgX);                                 // retn char result

       end-proc;                                                             // step with chr result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table, based on a
      *    numeric argument in a stepladder progression.

       dcl-proc XrefDStepN export;                                           // step with chr result

       dcl-pi XrefDStepN like(StdXrefF.dateres);                             // step with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         NumArg   like(StdXrefF.numarg)   const;                             // numeric argument
       end-pi;                                                               // step with dat result

       dcl-s NumArgX like(StdXrefF.numarg);                                  // numeric argument

       exec sql
         select max(numarg) into :NumArgX from StdXref
           where reftable  = :RefTable
             and numarg   <= :Numarg
             and chararg  <> :Marker;                                        // highest step reached

       return XrefDateN(RefTable : NumArgX);                                 // retn date result

       end-proc;                                                             // step with dat result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, based on a
      *    character argument in a stepladder progression.

       dcl-proc XrefNStepC export;                                           // step with num result

       dcl-pi XrefNStepC like(StdXrefF.numres);                              // step with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
       end-pi;                                                               // step with num result

       dcl-s CharArgX like(StdXrefF.chararg);                                // character argument

       exec sql
         select max(chararg) into :CharArgX from StdXref
           where reftable  = :RefTable
             and chararg  <= :CharArg
             and chararg  <> :Marker;                                        // highest step reached

       return XrefNumC(RefTable : CharArgX);                                 // retn numeric result

       end-proc;                                                             // step with num result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table, based on a
      *    character argument in a stepladder progression.

       dcl-proc XrefCStepC export;                                           // step with chr result

       dcl-pi XrefCStepC like(StdXrefF.charres);                             // step with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
       end-pi;                                                               // step with chr result

       dcl-s CharArgX like(StdXrefF.chararg);                                // character argument

       exec sql
         select max(chararg) into :CharArgX from StdXref
           where reftable  = :RefTable
             and chararg  <= :CharArg
             and chararg  <> :Marker;                                        // highest step reached

       return XrefCharC(RefTable : CharArgX);                                // retn char result

       end-proc;                                                             // step with chr result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table, based on a
      *    character argument in a stepladder progression.

       dcl-proc XrefDStepC export;                                           // step with dat result

       dcl-pi XrefDStepC like(StdXrefF.dateres);                             // step with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         CharArg  like(StdXrefF.chararg)  const;                             // character argument
       end-pi;                                                               // step with dat result

       dcl-s CharArgX like(StdXrefF.chararg);                                // character argument

       exec sql
         select max(chararg) into :CharArgX from StdXref
           where reftable  = :RefTable
             and chararg  <= :CharArg
             and chararg  <> :Marker;                                        // highest step reached

       return XrefDateC(RefTable : CharArgX);                                // retn date result

       end-proc;                                                             // step with dat result

      **********************************************************************************************
      *
      *  Retrieve a numeric result from a specified reference table, based on a
      *    date argument in a stepladder progression.

       dcl-proc XrefNStepD export;                                           // step with num result

       dcl-pi XrefNStepD like(StdXrefF.numres);                              // step with num result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // step with num result

       dcl-s DateArgX like(StdXrefF.datearg);                                // date argument

       exec sql
         select max(datearg) into :DateArgX from StdXref
           where reftable  = :RefTable
             and datearg  <= :DateArg
             and chararg  <> :Marker;                                        // highest step reached

       return XrefNumD(RefTable : DateArgX);                                 // retn numeric result

       end-proc;                                                             // step with num result

      **********************************************************************************************
      *
      *  Retrieve a character result from a specified reference table, based on a
      *    date argument in a stepladder progression.

       dcl-proc XrefCStepD export;                                           // step with chr result

       dcl-pi XrefCStepD like(StdXrefF.charres);                             // step with chr result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // step with chr result

       dcl-s DateArgX like(StdXrefF.datearg);                                // date argument

       exec sql
         select max(datearg) into :DateArgX from StdXref
           where reftable  = :RefTable
             and datearg  <= :DateArg
             and chararg  <> :Marker;                                        // highest step reached

       return XrefCharD(RefTable : DateArgX);                                // retn char result

       end-proc;                                                             // step with chr result

      **********************************************************************************************
      *
      *  Retrieve a date result from a specified reference table, based on a
      *    date argument in a stepladder progression.

       dcl-proc XrefDStepD export;                                           // step with dat result

       dcl-pi XrefDStepD like(StdXrefF.dateres);                             // step with dat result
         RefTable like(StdXrefF.reftable) const;                             // reference table
         DateArg  like(StdXrefF.datearg)  const;                             // date argument
       end-pi;                                                               // step with dat result

       dcl-s DateArgX like(StdXrefF.datearg);                                // date argument

       exec sql
         select max(datearg) into :DateArgX from StdXref
           where reftable  = :RefTable
             and datearg  <= :DateArg
             and chararg  <> :Marker;                                        // highest step reached

       return XrefDateD(RefTable : DateArgX);                                // retn date result

       end-proc;                                                             // step with dat result

