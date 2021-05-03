{ lib
, stdenv
, fetchFromGitHub
, bison
, meson
, ninja
, pkg-config
, libuecc
, libsodium
, libcap
, json_c
, openssl
}:

stdenv.mkDerivation rec {
  pname = "fastd";
  version = "21";

  src = fetchFromGitHub {
    owner  = "Neoraider";
    repo = "fastd";
    rev = "v${version}";
    sha256 = "1p4k50dk8byrghbr0fwmgwps8df6rlkgcd603r14i71m5g27z5gw";
  };

  nativeBuildInputs = [
    bison
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    json_c
    libcap
    libsodium
    libuecc
    openssl
  ];

  # some options are only available on x86
  mesonFlags = lib.optionals (!stdenv.isx86_64 && !stdenv.isi686) [
    "-Dcipher_salsa20_xmm=disabled"
    "-Dcipher_salsa2012_xmm=disabled"
    "-Dmac_ghash_pclmulqdq=disabled"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Fast and Secure Tunneling Daemon";
    homepage = "https://projects.universe-factory.net/projects/fastd/wiki";
    license = with licenses; [ bsd2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
