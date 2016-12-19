{stdenv, fetchurl, libaal}:

let version = "1.1.0"; in
stdenv.mkDerivation rec {
  name = "reiser4progs-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/reiser4-utils/${name}.tar.gz";
    sha256 = "18bgv0wd75q53642x5dsk4g0mil1hw1zrp7a4xkb0pxx4bzjlbqg";
  };

  buildInputs = [libaal];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace configure --replace " -static" ""
  '';

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  meta = {
    inherit version;
    homepage = http://www.namesys.com/;
    description = "Reiser4 utilities";
    platforms = stdenv.lib.platforms.linux;
  };
}
