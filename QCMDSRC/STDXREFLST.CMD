/******************************************************************************/
/*                                                                            */
/*  STANDARD CROSS REFERENCE LISTING                                          */
/*                                                                            */
/*  Copyright (C) 2006, 2021  Christopher F. Burns Sr.                        */
/*                                                                            */
/*  This program is free software: you can redistribute it and/or modify      */
/*  it under the terms of the GNU General Public License as published by      */
/*  the Free Software Foundation, either version 3 of the License, or         */
/*  (at your option) any later version.                                       */
/*                                                                            */
/*  This program is distributed in the hope that it will be useful,           */
/*  but WITHOUT ANY WARRANTY; without even the implied warranty of            */
/*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             */
/*  GNU General Public License for more details.                              */
/*                                                                            */
/*  You should have received a copy of the GNU General Public License         */
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>.     */
/*                                                                            */
/******************************************************************************/

             CMD        PROMPT('Std. Cross Reference Listing')

             PARM       KWD(REFTABLE) TYPE(*CHAR) LEN(15) MIN(1) +
                          CHOICE('Name, *ALL') PROMPT('Reference +
                          table')

             PARM       KWD(VERSION) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*CURRENT) VALUES(*CURRENT *LEGACY) +
                          CHOICE('*CURRENT, *LEGACY') +
                          PROMPT('Report Version')

