      **********************************************************************************************
      *                                                                                            *
      *  STANDARD CROSS REFERENCE APPLICATION FUNCTIONS                                            *
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

       dcl-ds StdXrefF extname('STDXREF') qualified template end-ds;         // for definition only

       dcl-pr XrefNum like(StdXrefF.NumRes);                                 // xref with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumN like(StdXrefF.NumRes);                                // xref with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumC like(StdXrefF.NumRes);                                // xref with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumD like(StdXrefF.NumRes);                                // xref with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumNC like(StdXrefF.NumRes);                               // xref with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumND like(StdXrefF.NumRes);                               // xref with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefNumCD like(StdXrefF.NumRes);                               // xref with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with num result

       dcl-pr XrefChar like(StdXrefF.CharRes);                               // xref with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharN like(StdXrefF.CharRes);                              // xref with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharC like(StdXrefF.CharRes);                              // xref with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharD like(StdXrefF.CharRes);                              // xref with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharNC like(StdXrefF.CharRes);                             // xref with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharND like(StdXrefF.CharRes);                             // xref with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefCharCD like(StdXrefF.CharRes);                             // xref with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with chr result

       dcl-pr XrefDate like(StdXrefF.DateRes);                               // xref with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateN like(StdXrefF.DateRes);                              // xref with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateC like(StdXrefF.DateRes);                              // xref with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateD like(StdXrefF.DateRes);                              // xref with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateNC like(StdXrefF.DateRes);                             // xref with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateND like(StdXrefF.DateRes);                             // xref with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with dat result

       dcl-pr XrefDateCD like(StdXrefF.DateRes);                             // xref with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // xref with dat result

       dcl-pr IncrXrefNum like(StdXrefF.NumRes);                             // increment xref num
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
         IncrVal  like(StdXrefF.NumRes)   const;                             // increment value
       end-pr;                                                               // increment xref num

       dcl-pr IncrXrefDate like(StdXrefF.DateRes);                           // increment xref date
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
         IncrDays like(StdXrefF.NumArg)   const;                             // increment num days
       end-pr;                                                               // increment xref date

       dcl-pr XrefNStepN like(StdXrefF.NumRes);                              // step with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
       end-pr;                                                               // step with num result

       dcl-pr XrefCStepN like(StdXrefF.CharRes);                             // step with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
       end-pr;                                                               // step with chr result

       dcl-pr XrefDStepN like(StdXrefF.DateRes);                             // step with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         NumArg   like(StdXrefF.NumArg)   const;                             // numeric argument
       end-pr;                                                               // step with dat result

       dcl-pr XrefNStepC like(StdXrefF.NumRes);                              // step with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
       end-pr;                                                               // step with num result

       dcl-pr XrefCStepC like(StdXrefF.CharRes);                             // step with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
       end-pr;                                                               // step with chr result

       dcl-pr XrefDStepC like(StdXrefF.DateRes);                             // step with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         CharArg  like(StdXrefF.CharArg)  const;                             // character argument
       end-pr;                                                               // step with dat result

       dcl-pr XrefNStepD like(StdXrefF.NumRes);                              // step with num result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // step with num result

       dcl-pr XrefCStepD like(StdXrefF.CharRes);                             // step with chr result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // step with chr result

       dcl-pr XrefDStepD like(StdXrefF.DateRes);                             // step with dat result
         RefTable like(StdXrefF.RefTable) const;                             // reference table
         DateArg  like(StdXrefF.DateArg)  const;                             // date argument
       end-pr;                                                               // step with dat result

