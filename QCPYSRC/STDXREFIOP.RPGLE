      **********************************************************************************************
      *                                                                                            *
      *  STANDARD CROSS REFERENCE I/O PROCEDURES                                                   *
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

       dcl-ds StdXrefI extname('STDXREF') qualified template end-ds;         // for definition only

       dcl-pr FindXrefNum like(StdXrefI.numarg);                             // find xref num arg
         RefTable like(StdXrefI.reftable) const;                             // reference table
         PrvValue like(StdXrefI.numarg)   const options(*nopass);            // previous value
       end-pr;                                                               // find xref num arg

       dcl-pr FindXrefChar like(StdXrefI.chararg);                           // find xref char arg
         RefTable like(StdXrefI.reftable) const;                             // reference table
         PrvValue like(StdXrefI.chararg)  const options(*nopass);            // previous value
       end-pr;                                                               // find xref char arg

       dcl-pr OKToDelete ind;                                                // OK to delete
         Default char(1) const options(*nopass);                             // default value
       end-pr;                                                               // OK to delete

       dcl-pr ValidXref ind;                                                 // valid xref entry
         RefTable like(StdXrefI.reftable) const;                             // reference table
         NumArg   like(StdXrefI.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefI.chararg)  const;                             // character argument
         DateArg  like(StdXrefI.datearg)  const;                             // date argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefN ind;                                                // valid xref entry
         RefTable like(StdXrefI.reftable) const;                             // reference table
         NumArg   like(StdXrefI.numarg)   const;                             // numeric argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefC ind;                                                // valid xref entry
         RefTable like(StdXrefI.reftable) const;                             // reference table
         CharArg  like(StdXrefI.chararg)  const;                             // character argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefD ind;                                                // valid xref entry
         RefTable like(StdXrefI.reftable) const;                             // reference table
         DateArg  like(StdXrefI.datearg)  const;                             // date argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefNC ind;                                               // valid xref entry
         RefTable like(StdXrefI.reftable) const;                             // reference table
         NumArg   like(StdXrefI.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefI.chararg)  const;                             // character argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefND ind;                                               // valid xref entry
         RefTable like(StdXrefI.reftable) const;                             // reference table
         NumArg   like(StdXrefI.numarg)   const;                             // numeric argument
         DateArg  like(StdXrefI.datearg)  const;                             // date argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefCD ind;                                               // valid xref entry
         RefTable like(StdXrefI.reftable) const;                             // reference table
         CharArg  like(StdXrefI.chararg)  const;                             // character argument
         DateArg  like(StdXrefI.datearg)  const;                             // date argument
       end-pr;                                                               // valid xref entry

       dcl-pr putXrefTable ind;                                              // put xref table hdr
         RefTable    like(StdXrefI.reftable) const;                          // reference table
         Description like(StdXrefI.charres)  const;                          // table description
       end-pr;                                                               // put xref table hdr

       dcl-pr putXrefEntry ind;                                              // put xref table entry
         RefTable like(StdXrefI.reftable) const;                             // reference table
         NumArg   like(StdXrefI.numarg)   const;                             // numeric argument
         CharArg  like(StdXrefI.chararg)  const;                             // character argument
         DateArg  like(StdXrefI.datearg)  const;                             // date argument
         NumRes   like(StdXrefI.numres)   const;                             // numeric result
         CharRes  like(StdXrefI.charres)  const;                             // character result
         DateRes  like(StdXrefI.dateres)  const;                             // date result
         Hidden   like(StdXrefI.hidden)   const;                             // hidden from search
       end-pr;                                                               // put xref table entry

       dcl-pr FindXrefArg like(StdXrefI.chararg);                            // find xref argument
         RefTable like(StdXrefI.reftable) const;                             // reference table
         ArgType  like(StdXrefI.hidden)   const;                             // argument type
         ResType  like(StdXrefI.hidden)   const;                             // result type shown
       end-pr;                                                               // find xref argument

       dcl-pr FindXrefArgN like(StdXrefI.numarg);                            // find xref num arg
         RefTable like(StdXrefI.reftable) const;                             // reference table
         PrvValue like(StdXrefI.numarg)   const options(*nopass);            // previous value
         ResType  like(StdXrefI.hidden)   const options(*nopass);            // result type shown
       end-pr;                                                               // find xref num arg

       dcl-pr FindXrefArgC like(StdXrefI.chararg);                           // find xref char arg
         RefTable like(StdXrefI.reftable) const;                             // reference table
         PrvValue like(StdXrefI.chararg)  const options(*nopass);            // previous value
         ResType  like(StdXrefI.hidden)   const options(*nopass);            // result type shown
       end-pr;                                                               // find xref char arg

       dcl-pr FindXrefArgD like(StdXrefI.datearg);                           // find xref date arg
         RefTable like(StdXrefI.reftable) const;                             // reference table
         PrvValue like(StdXrefI.datearg)  const options(*nopass);            // previous value
         ResType  like(StdXrefI.hidden)   const options(*nopass);            // result type shown
       end-pr;                                                               // find xref date arg

       dcl-pr PrintXrefTable;                                                // print xref table
         RefTable like(StdXrefI.RefTable) value options(*nopass);            // reference table
       end-pr;                                                               // print xref table

       dcl-s Marker like(StdXrefI.CharArg) inz('REFTABLE');                  // table header marker

