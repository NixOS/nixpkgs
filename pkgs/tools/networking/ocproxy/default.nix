{ stdenv, fetchFromGitHub, autoconf, automake, libevent }:

stdenv.mkDerivation rec {
  version = "1.50";
  name = "ocproxy-${version}";

  src = fetchFromGitHub {
    owner = "cernekee";
    repo = "ocproxy";
    rev = "v${version}";
    sha256 = "136vlk2svgls5paf17xi1zahcahgcnmi2p55khh7zpqaar4lzw6s";
  };

  buildInputs = [ autoconf automake libevent ];

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "OpenConnect proxy";
    longdescription = ''
      ocproxy is a user-level SOCKS and port forwarding proxy for OpenConnect
      based on lwIP.
    '';
    homepage = https://github.com/cernekee/ocproxy;
    license = licenses.bsd3;
    maintainers = [ maintainers.joko ];
    platforms = platforms.unix;
  };
}
