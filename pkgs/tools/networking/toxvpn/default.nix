{ stdenv, fetchFromGitHub, cmake, lib
, libtoxcore, jsoncpp, libsodium, systemd, libcap }:

with lib;

stdenv.mkDerivation rec {
  name = "toxvpn-${version}";
  version = "20161230";

  src = fetchFromGitHub {
    owner  = "cleverca22";
    repo   = "toxvpn";
    rev    = "4b7498a5fae680484cb5779ac01fb08ad3089bdd";
    sha256 = "0bazdspiym9xyzms7pd6i1f2gph13rnf764nm3jc27fbfwmc98rp";
  };

  buildInputs = [ libtoxcore jsoncpp libsodium libcap ] ++ optional stdenv.isLinux systemd;
  nativeBuildInputs = [ cmake ];

  cmakeFlags = optional stdenv.isLinux [ "-DSYSTEMD=1" ];

  meta = with stdenv.lib; {
    description = "A powerful tool that allows one to make tunneled point to point connections over Tox";
    homepage    = https://github.com/cleverca22/toxvpn;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ cleverca22 obadz ];
    platforms   = platforms.linux;
  };
}
