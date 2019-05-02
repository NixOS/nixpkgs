{ stdenv, fetchurl, perlPackages, makeWrapper }:

perlPackages.buildPerlPackage rec {
  name = "File-Rename-0.20";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RM/RMBARKER/${name}.tar.gz";
    sha256 = "1cf6xx2hiy1xalp35fh8g73j67r0w0g66jpcbc6971x9jbm7bvjy";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/rename \
      --prefix PERL5LIB : $out/${perlPackages.perl.libPrefix}
  '';

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Perl extension for renaming multiple files";
    license = licenses.artistic1;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
