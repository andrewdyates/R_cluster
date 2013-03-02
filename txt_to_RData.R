http://stackoverflow.com/questions/2151212/how-can-i-read-command-line-parameters-from-an-r-script/2151627#2151627

A few points:

  Command-line parameters are accessible via commandArgs(), so see help(commandArgs) for an overview.

You can use Rscript.exe on all platforms, including Windows. It will support commandArgs(). littler could be ported to Windows but lives right now only on OS X and Linux.

There are two add-on packages on CRAN -- getopt and optparse -- which were both written for command-line parsing.


# read .tab file, save as .R object with changed file extension in same directory
