$latex = 'uplatex -shell-escape -synctex=1 -interaction=nonstopmode %O %S';
$bibtex = 'upbibtex %O %B';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'upmendex %O -o %D %S';
$max_repeat = 10;

# For use of graphviz package.

# Use internal latexmk variable to find the names of the pdf file(s)
# to be created by dot.
push @file_not_found, 'runsystem\(dot -Tpdf -o ([^ ]+) ';

add_cus_dep( 'dot', 'pdf', 0, 'dottopdf' );
sub dottopdf {
  system( "dot", "-Tpdf", "-o", "$_[0].pdf", "$_[0].dot" );
}
