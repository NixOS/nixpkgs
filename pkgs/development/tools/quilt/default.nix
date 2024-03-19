{ lib
, stdenv
, fetchurl
, makeWrapper
, bash
, coreutils
, diffstat
, diffutils
, findutils
, gawk
, gnugrep
, gnused
, patch
, perl
, unixtools
}:

stdenv.mkDerivation rec {

  pname = "quilt";
  version = "0.67";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-O+O+CYfnKmw2Rni7gn4+H8wQMitWvF8CtXZpj1UBPMI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    bash
    coreutils
    diffstat
    diffutils
    findutils
    gawk
    gnugrep
    gnused
    patch
    perl
    unixtools.column
    unixtools.getopt
  ];

  postInstall = ''
    wrapProgram $out/bin/quilt --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  meta = with lib; {
    homepage = "https://savannah.nongnu.org/projects/quilt";
    description = "Easily manage large numbers of patches";

    longDescription = ''
      Quilt allows you to easily manage large numbers of
      patches by keeping track of the changes each patch
      makes. Patches can be applied, un-applied, refreshed,
      and more.
    '';

    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ smancill ];
    platforms = platforms.all;
  };

}
