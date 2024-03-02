{ lib, runCommand, makeWrapper, parallel, perlPackages
, extraPerlPackages ? with perlPackages; [ DBI DBDPg DBDSQLite DBDCSV TextCSV ]
, willCite ? false }:

runCommand "parallel-full" { nativeBuildInputs = [ makeWrapper ]; } ''
  mkdir -p $out/bin
  makeWrapper ${parallel}/bin/parallel $out/bin/parallel \
    --set PERL5LIB "${perlPackages.makeFullPerlPath extraPerlPackages}" \
    ${lib.optionalString willCite "--add-flags --will-cite"}
''
