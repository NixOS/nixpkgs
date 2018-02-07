{ stdenv, fetchFromGitHub, libpcap, pixiewps, makeWrapper }:

stdenv.mkDerivation rec {
  version = "1.6.3";
  name = "reaver-wps-t6x-${version}";

  src = fetchFromGitHub {
    owner = "t6x";
    repo = "reaver-wps-fork-t6x";
    rev = "v${version}";
    sha256 = "1bccwp67q1q0h5m38gqxn9imq5rb75jbmv7fjr2n38v10jcga2pb";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libpcap pixiewps ];

  preConfigure = "cd src";

  installPhase = ''
    mkdir -p $out/bin
    cp reaver wash $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Online and offline brute force attack against WPS";
    homepage = https://github.com/t6x/reaver-wps-fork-t6x;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nico202 volth ];
  };
}
