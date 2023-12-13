{ lib, stdenv, fetchFromGitHub, autoconf, automake, libevent }:

stdenv.mkDerivation rec {
  version = "1.60";
  pname = "ocproxy";

  src = fetchFromGitHub {
    owner = "cernekee";
    repo = "ocproxy";
    rev = "v${version}";
    sha256 = "03323nnhb4y9nzwva04mq7xg03dvdrgp689g89f69jqc261skcqx";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ libevent ];

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  meta = with lib; {
    description = "OpenConnect proxy";
    longDescription = ''
      ocproxy is a user-level SOCKS and port forwarding proxy for OpenConnect
      based on lwIP.
    '';
    homepage = "https://github.com/cernekee/ocproxy";
    license = licenses.bsd3;
    maintainers = [ maintainers.joko ];
    platforms = platforms.unix;
  };
}
