{stdenv, fetchurl, libaal}:

let version = "1.0.9"; in
stdenv.mkDerivation rec {
  name = "reiser4progs-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/reiser4-utils/${name}.tar.gz";
    sha256 = "0d6djyd7wjvzbqj738b2z4jr5c2s30g8q8xygipyi0007g42gc7z";
  };

  buildInputs = [libaal];

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
  };
}
