{ lib, stdenv, fetchurl, perl, perlPackages }:

perlPackages.buildPerlPackage {
  pname = "File-Rename";
  version = "0.20";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RM/RMBARKER/File-Rename-0.20.tar.gz";
    sha256 = "1cf6xx2hiy1xalp35fh8g73j67r0w0g66jpcbc6971x9jbm7bvjy";
  };

  # Fix an incorrect platform test that misidentifies Darwin as Windows
  postPatch = ''
    substituteInPlace Makefile.PL \
      --replace '/win/i' '/MSWin32/'
  '';

  postFixup = ''
    substituteInPlace $out/bin/rename \
      --replace "#!${perl}/bin/perl" "#!${perl}/bin/perl -I $out/${perl.libPrefix}"
  '';

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Perl extension for renaming multiple files";
    license = licenses.artistic1;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "rename";
  };
}
