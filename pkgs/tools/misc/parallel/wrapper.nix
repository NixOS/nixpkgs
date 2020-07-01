{ parallel, makeWrapper , runCommand
, perlPackages
, extraPerlPackages ?
    with perlPackages; [ DBI DBDPg DBDSQLite DBDCSV TextCSV ]
}:

runCommand "parallel-full" {
  nativeBuildInputs = [ makeWrapper ];
  } ''
      mkdir -p $out/bin
      makeWrapper ${parallel}/bin/parallel $out/bin/parallel \
        --set PERL5LIB "${perlPackages.makeFullPerlPath extraPerlPackages}"
  ''
