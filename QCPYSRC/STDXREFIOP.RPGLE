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

       dcl-ds StdXref extname('STDXREF') qualified template end-ds;          // for definition only

       dcl-pr XrefNum like(stdxref.numres);                                  // xref with num result
         RefTable like(stdxref.reftable) const;                              // reference table name
         NumArg   like(stdxref.numarg)   const;                              // numeric argument
         CharArg  like(stdxref.chararg)  const;                              // character argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumN like(StdXref.numres);                                 // xref with num result
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumC like(StdXref.numres);                                 // xref with num result
         RefTable like(StdXref.reftable) const;                              // reference table name
         CharArg  like(StdXref.chararg)  const;                              // character argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefChar like(stdxref.charres);                                // xref with chr result
         RefTable like(stdxref.reftable) const;                              // reference table name
         NumArg   like(stdxref.numarg)   const;                              // numeric argument
         CharArg  like(stdxref.chararg)  const;                              // character argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharN like(StdXref.charres);                               // xref with chr result
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharC like(StdXref.charres);                               // xref with chr result
         RefTable like(StdXref.reftable) const;                              // reference table name
         CharArg  like(StdXref.chararg)  const;                              // character argument
       end-pr;                                                               // xref with chr result

       dcl-pr FindXrefNum like(stdxref.numarg);                              // find xref num arg
         RefTable like(stdxref.reftable) const;                              // reference table
         PrvValue like(stdxref.numarg)   const options(*nopass);             // previous value
       end-pr;                                                               // find xref num arg

       dcl-pr FindXrefChar like(stdxref.chararg);                            // find xref char arg
         RefTable like(stdxref.reftable) const;                              // reference table
         PrvValue like(stdxref.chararg)  const options(*nopass);             // previous value
       end-pr;                                                               // find xref char arg

       dcl-pr OKToDelete ind;                                                // OK to delete
         Default char(1) const options(*nopass);                             // default value
       end-pr;                                                               // OK to delete

       dcl-pr ValidXref ind;                                                 // valid xref entry
         RefTable like(stdxref.reftable) const;                              // reference table name
         NumArg   like(stdxref.numarg)   const;                              // numeric argument
         CharArg  like(stdxref.chararg)  const;                              // character argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefN ind;                                                // valid xref entry
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
       end-pr;                                                               // valid xref entry

       dcl-pr ValidXrefC ind;                                                // valid xref entry
         RefTable like(StdXref.reftable) const;                              // reference table name
         CharArg  like(StdXref.chararg)  const;                              // character argument
       end-pr;                                                               // valid xref entry

       dcl-pr putXrefTable ind;                                              // put xref table hdr
         RefTable    like(StdXref.reftable) const;                           // reference table name
         Description like(StdXref.charres)  const;                           // table description
       end-pr;                                                               // put xref table hdr

       dcl-pr putXrefEntry ind;                                              // put xref table entry
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
         CharArg  like(StdXref.chararg)  const;                              // character argument
         NumRes   like(StdXref.numres)   const;                              // numeric result
         CharRes  like(StdXref.charres)  const;                              // character result
         Hidden   like(StdXref.hidden)   const;                              // hidden from search
       end-pr;                                                               // put xref table entry

       dcl-pr IncrXrefNum like(StdXref.numres);                              // increment xref num
         RefTable like(StdXref.reftable) const;                              // reference table name
         NumArg   like(StdXref.numarg)   const;                              // numeric argument
         CharArg  like(StdXref.chararg)  const;                              // character argument
         IncrVal  like(StdXref.numres)   const;                              // increment value
       end-pr;                                                               // increment xref num

       dcl-s Marker like(StdXref.CharArg) inz('REFTABLE');                   // table header marker

