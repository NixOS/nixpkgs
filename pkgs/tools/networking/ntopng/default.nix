{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, bash, autoreconfHook
, zeromq, ndpi, json_c, openssl, libpcap, libcap, curl, libmaxminddb
, rrdtool, sqlite, libmysqlclient, expat, net-snmp
}:

stdenv.mkDerivation rec {
  pname = "ntopng";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "ntopng";
    rev = version;
    sha256 = "sha256-FeRERSq8F3HEelUCkA6pgNNcP94xrWy6EbJgk+cEdqc=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ntop/ntopng/commit/0aa580e1a45f248fffe6d11729ce40571f08e187.patch";
      sha256 = "sha256-xqEVwfGgkNS+akbJnLZsVvEQdp9GxxUen8VkFomtcPI=";
    })
  ];

  nativeBuildInputs = [ bash autoreconfHook pkg-config ];

  buildInputs = [
    zeromq ndpi json_c openssl libpcap curl libmaxminddb rrdtool sqlite
    libmysqlclient expat net-snmp libcap
  ];

  autoreconfPhase = "bash autogen.sh";

  preConfigure = ''
    substituteInPlace Makefile.in --replace "/bin/rm" "rm"
  '';

  preBuild = ''
    sed -e "s|\(#define CONST_BIN_DIR \).*|\1\"$out/bin\"|g" \
        -e "s|\(#define CONST_SHARE_DIR \).*|\1\"$out/share\"|g" \
        -i include/ntop_defines.h
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "High-speed web-based traffic analysis and flow collection tool";
    homepage = "http://www.ntop.org/products/ntop/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
