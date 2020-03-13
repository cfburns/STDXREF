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

       dcl-ds StdXrefF extname('STDXREF') qualified template end-ds;         // for definition only

       dcl-pr XrefNum like(StdXrefF.numres);                                 // xref with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumN like(StdXrefF.numres);                                // xref with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumC like(StdXrefF.numres);                                // xref with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumD like(StdXrefF.numres);                                // xref with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumNC like(StdXrefF.numres);                               // xref with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumND like(StdXrefF.numres);                               // xref with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumCD like(StdXrefF.numres);                               // xref with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefChar like(StdXrefF.charres);                               // xref with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharN like(StdXrefF.charres);                              // xref with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharC like(StdXrefF.charres);                              // xref with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharD like(StdXrefF.charres);                              // xref with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharNC like(StdXrefF.charres);                             // xref with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharND like(StdXrefF.charres);                             // xref with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharCD like(StdXrefF.charres);                             // xref with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefDate like(StdXrefF.dateres);                               // xref with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateN like(StdXrefF.dateres);                              // xref with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateC like(StdXrefF.dateres);                              // xref with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateD like(StdXrefF.dateres);                              // xref with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateNC like(StdXrefF.dateres);                             // xref with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateND like(StdXrefF.dateres);                             // xref with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateCD like(StdXrefF.dateres);                             // xref with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // xref with dat result

       dcl-pr IncrXrefNum like(StdXrefF.numres);                             // increment xref num
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
         IncrVal  like(StdXrefF.numres)   const;                              // increment value
       end-pr;                                                               // increment xref num

       dcl-pr IncrXrefDate like(StdXrefF.dateres);                           // increment xref date
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
         IncrDays like(StdXrefF.numarg)   const;                              // increment num days
       end-pr;                                                               // increment xref date

       dcl-pr XrefNStepN like(StdXrefF.numres);                              // step with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
       end-pr;                                                               // step with num result

       dcl-pr XrefCStepN like(StdXrefF.charres);                             // step with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
       end-pr;                                                               // step with chr result

       dcl-pr XrefDStepN like(StdXrefF.dateres);                             // step with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         NumArg   like(StdXrefF.numarg)   const;                              // numeric argument
       end-pr;                                                               // step with dat result

       dcl-pr XrefNStepC like(StdXrefF.numres);                              // step with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
       end-pr;                                                               // step with num result

       dcl-pr XrefCStepC like(StdXrefF.charres);                             // step with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
       end-pr;                                                               // step with chr result

       dcl-pr XrefDStepC like(StdXrefF.dateres);                             // step with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         CharArg  like(StdXrefF.chararg)  const;                              // character argument
       end-pr;                                                               // step with dat result

       dcl-pr XrefNStepD like(StdXrefF.numres);                              // step with num result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // step with num result

       dcl-pr XrefCStepD like(StdXrefF.charres);                             // step with chr result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // step with chr result

       dcl-pr XrefDStepD like(StdXrefF.dateres);                             // step with dat result
         RefTable like(StdXrefF.reftable) const;                              // reference table
         DateArg  like(StdXrefF.datearg)  const;                              // date argument
       end-pr;                                                               // step with dat result

