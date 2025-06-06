{lib, stdenv, fetchurl, libaal}:

stdenv.mkDerivation rec {
  pname = "reiser4progs";
  version = "2.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/reiser4-utils/${pname}-${version}.tar.gz";
    sha256 = "sha256-DBR2C5h6ue4aqHmDG50jCLXe13DSWAYwfibrzTM+7Sw=";
  };

  buildInputs = [libaal];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace configure --replace " -static" ""
  '';

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  # this required for wipefreespace
  postInstall = ''
    mkdir -p $out/lib
    cp ./libmisc/.libs/libmisc.a $out/lib/libreiser4misc.a.la
  '';

  meta = with lib; {
    inherit version;
    homepage = "https://sourceforge.net/projects/reiser4/";
    description = "Reiser4 utilities";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
