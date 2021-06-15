{lib, stdenv, fetchurl, libaal}:

let version = "2.0.4"; in
stdenv.mkDerivation rec {
  pname = "reiser4progs";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/reiser4-utils/${pname}-${version}.tar.gz";
    sha256 = "sha256-WmIkISnRp5BngSfPEKY95HVEt5TBtPKu+RMBwlLsnuA=";
  };

  buildInputs = [libaal];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace configure --replace " -static" ""
  '';

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  meta = with lib; {
    inherit version;
    homepage = "https://sourceforge.net/projects/reiser4/";
    description = "Reiser4 utilities";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
