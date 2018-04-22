/******************************************************************************/
/*                                                                            */
/*  STANDARD CROSS REFERENCE - INSTALLATION COMMAND                           */
/*                                                                            */
/*  Copyright (C) 2006, 2018  Christopher F. Burns Sr.                        */
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

             CMD        PROMPT('Install Standard X-Reference')

             PARM       KWD(INSLIB) TYPE(*NAME) MIN(1) +
                          PROMPT('Installation Library')

             PARM       KWD(USRPRF) TYPE(*NAME) MIN(1) PROMPT('Owner +
                          User Profile')

