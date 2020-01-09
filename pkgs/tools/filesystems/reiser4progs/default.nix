{stdenv, fetchurl, libaal}:

let version = "2.0.0"; in
stdenv.mkDerivation rec {
  pname = "reiser4progs";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/reiser4/reiser4-utils/${pname}-${version}.tar.gz";
    sha256 = "00kx9prz3d5plp1hn4xdkkd99cw42sanlsjnjhj0fsrlmi9yfs8n";
  };

  buildInputs = [libaal];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace configure --replace " -static" ""
  '';

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  meta = with stdenv.lib; {
    inherit version;
    homepage = https://sourceforge.net/projects/reiser4/;
    description = "Reiser4 utilities";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
