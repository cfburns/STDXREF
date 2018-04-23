# STDXREF (Standalone Version)


The Standard Cross Reference is a simple tool that provides a centralized container for:

  * Data elements that have a finite number of valid values, which need to be validated before being written to an application database.
  * Descriptions, codes or numeric values associated with those data elements, which need to be looked up by an application program.
  * Random pieces of information that control the behavior of an application.

Many companies have adopted a “table file” or “code file” over the years as a means to consolidate random pieces of information or groups of related pieces. However many of these files contained multiple record layouts which often meant hard coding Input specs into RPG. And since the “table file” still had to be read by RPG, a significant amount of non-productive code was required by application programs in order to use it…such as File specs, key lists, chain operations and no-hit handling.

STDXREF was born in 2006, during database modernization and refit of a line-of-business application rooted in the System/36 environment, replete with compile-time tables in the RPG36 code. Plus, many of these tables were present in multiple programs, hence a change to one table meant modifications to multiple programs (an example of Technical Debt).  The refit also included a migration to ILE-RPG.

Implementing STDXREF meant eliminating countless compile time tables from the RPG code, entering data from the table entries into the STDXREF file, and replacing legacy RPG lookup operations with sleek function calls that fit new freeform RPG paradigm. It also provided a means for authorized users to update the reference tables without having to involve IT for RPG edits and compiles.

Theoretically, you could provide an individual data base file/table for each type of data relationship contained in an RPG compile-time table, but that might require a maintenance program and a listing query for each one. Plus the RPG application programs would still require a File spec (or SQL SELECT) for each table.

Using STDXREF instead provides these advantages:

  * Single point of maintenance (program STDXREFMNT).
  * Single point of retrieval (STDXREFIOP functions).
  * Single point of high availability replication (table STDXREF).
  * Add to an application program with a single /COPY statement.
  * Option for multiple instances of STDXREF on the same system.

Now that STDXREF is on GitHub, we encourage you to download and deploy it for your internal applications. Being open source, it is still a work in progress. Please consider submitting suggestions for its improvement or even contributing your technical expertise to help us improve the functionality.

Note that STDXREF is simplistic and does not contain any audit trail capabilities. An alternate version of STDXREF for Inuendo databases is under construction and will take full advantage of Inuendo’s self-journaling and audit trail features. This will appear on GitHub when it is released.
