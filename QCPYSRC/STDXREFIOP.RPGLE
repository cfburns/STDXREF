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

       dcl-ds StdXrefI extname('STDXREF') qualified template end-ds;         // for definition only

       dcl-pr FindXrefNum like(StdXrefI.numarg);                             // find xref num arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.NumArg)   const options(*nopass);            // previous value
       end-pr;                                                               // find xref num arg

       dcl-pr FindXrefChar like(StdXrefI.CharArg);                           // find xref char arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.CharArg)  const options(*nopass);            // previous value
       end-pr;                                                               // find xref char arg

       dcl-pr OKToDelete ind;                                                // OK to delete
         Default char(1) const options(*nopass);                             // default value
       end-pr;                                                               // OK to delete

       dcl-pr ValidXref ind;                                                 // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
         DateArg  like(StdXrefI.DateArg)  const options(*nopass);            // date argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefN ind;                                                // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefC ind;                                                // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefD ind;                                                // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         DateArg  like(StdXrefI.DateArg)  const;                             // date argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefNC ind;                                               // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefND ind;                                               // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
         DateArg  like(StdXrefI.DateArg)  const;                             // date argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefCD ind;                                               // valid xref entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
         DateArg  like(StdXrefI.DateArg)  const;                             // date argument
       end-pr;                                                               // valid xref entry

       dcl-pr putXrefTable ind;                                              // put xref table hdr
         RefTable    like(StdXrefI.RefTable) const;                          // reference table
         Description like(StdXrefI.CharRes)  const;                          // table description
       end-pr;                                                               // put xref table hdr

       dcl-pr putXrefEntry ind;                                              // put xref table entry
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         NumArg   like(StdXrefI.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefI.CharArg)  const;                             // character argument
         DateArg  like(StdXrefI.DateArg)  const;                             // date argument
         NumRes   like(StdXrefI.NumRes)   const;                             // numeric result
         CharRes  like(StdXrefI.CharRes)  const;                             // character result
         DateRes  like(StdXrefI.DateRes)  const;                             // date result
         Hidden   like(StdXrefI.Hidden)   const;                             // hidden from search
       end-pr;                                                               // put xref table entry

       dcl-pr FindXrefArg like(StdXrefI.CharArg);                            // find xref argument
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         ArgType  like(StdXrefI.Hidden)   const;                             // argument type
         ResType  like(StdXrefI.Hidden)   const;                             // result type shown
       end-pr;                                                               // find xref argument

       dcl-pr FindXrefArgN like(StdXrefI.NumArg);                            // find xref num arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.NumArg)   const options(*nopass);            // previous value
         ResType  like(StdXrefI.Hidden)   const options(*nopass);            // result type shown
       end-pr;                                                               // find xref num arg

       dcl-pr FindXrefArgC like(StdXrefI.CharArg);                           // find xref char arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.CharArg)  const options(*nopass);            // previous value
         ResType  like(StdXrefI.Hidden)   const options(*nopass);            // result type shown
       end-pr;                                                               // find xref char arg

       dcl-pr FindXrefArgD like(StdXrefI.DateArg);                           // find xref date arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         PrvValue like(StdXrefI.DateArg)  const options(*nopass);            // previous value
         ResType  like(StdXrefI.Hidden)   const options(*nopass);            // result type shown
       end-pr;                                                               // find xref date arg

       dcl-pr PrintXrefTable;                                                // print xref table
         RefTable like(StdXrefI.RefTable) value options(*nopass);            // reference table
       end-pr;                                                               // print xref table

       dcl-pr UserNumber int(20);                                            // user profile number
         UserID char(10) const;                                              // user ID
       end-pr;                                                               // user profile number

       dcl-pr isSuperAdmin ind;                                              // user is super admin
         UserProfile char(10) const options(*nopass);                        // user profile
       end-pr;                                                               // user is super admin

       dcl-pr isTableAdmin ind;                                              // user is table admin
         RefTable like(StdXrefI.RefTable) const;                             // reference table
         UserProfile char(10) const options(*nopass);                        // user profile
       end-pr;                                                               // user is table admin

       dcl-pr getTableID like(StdXrefI.EntityID);                            // get table entity ID
         RefTable like(StdXrefI.RefTable) const;                             // reference table
       end-pr;                                                               // get table entity ID

       dcl-pr NumberOfEntries int(5);                                        // number of entries
         RefTable like(StdXrefI.RefTable) const;                             // reference table
       end-pr;                                                               // number of entries

       dcl-pr isNumericArg ind;                                              // xref is numeric arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
       end-pr;                                                               // xref is numeric arg

       dcl-pr isDateArg ind;                                                 // xref is date arg
         RefTable like(StdXrefI.RefTable) const;                             // reference table
       end-pr;                                                               // xref is date arg

       dcl-s Marker     like(StdXrefI.CharArg)  inz('REFTABLE');             // table header marker
       dcl-s SuperAdmin like(StdXrefI.RefTable) inz('SUPERADMIN');           // super admin table
       dcl-s TableAdmin like(StdXrefI.RefTable) inz('TABLEADMIN');           // table admin table
       dcl-s TableGuide like(StdXrefI.RefTable) inz('TABLEGUIDE');           // table guide table
       dcl-s LowDate    like(StdXrefI.DateArg)  inz;                         // low date value

