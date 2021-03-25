{ lib, stdenv, fetchFromGitHub, bison, meson, ninja, pkg-config
, libuecc, libsodium, libcap, json_c, openssl }:

stdenv.mkDerivation rec {
  pname = "fastd";
  version = "21";

  src = fetchFromGitHub {
    owner  = "Neoraider";
    repo = "fastd";
    rev = "v${version}";
    sha256 = "1p4k50dk8byrghbr0fwmgwps8df6rlkgcd603r14i71m5g27z5gw";
  };

  nativeBuildInputs = [ pkg-config bison meson ninja ];
  buildInputs = [ libuecc libsodium libcap json_c openssl ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Fast and Secure Tunneling Daemon";
    homepage = "https://projects.universe-factory.net/projects/fastd/wiki";
    license = with licenses; [ bsd2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
