{ lib
, stdenv
, autoreconfHook
, curl
, expat
, fetchFromGitHub
, git
, json_c
, libcap
, libmaxminddb
, libmysqlclient
, libpcap
, libsodium
, ndpi
, net-snmp
, openssl
, pkg-config
, rdkafka
, gtest
, rrdtool
, hiredis
, sqlite
, which
, zeromq
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntopng";
  version = "6.0";

  src = fetchFromGitHub {
    owner = "ntop";
    repo = "ntopng";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-zLtJ4x1eWtvnd60iNuNkMOX8LinZMEJHSt/Y0FVQ8vw=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    substituteInPlace Makefile.in \
      --replace "/bin/rm" "rm"
  '';

  nativeBuildInputs = [
    autoreconfHook
    git
    pkg-config
    which
  ];

  buildInputs = [
    curl
    expat
    json_c
    libcap
    libmaxminddb
    libmysqlclient
    libpcap
    gtest
    hiredis
    libsodium
    net-snmp
    openssl
    rdkafka
    rrdtool
    sqlite
    zeromq
  ];

  autoreconfPhase = "bash autogen.sh";

  configureFlags = [
    "--with-ndpi-includes=${ndpi}/include/ndpi"
    "--with-ndpi-static-lib=${ndpi}/lib/"
  ];

  preBuild = ''
    sed -e "s|\(#define CONST_BIN_DIR \).*|\1\"$out/bin\"|g" \
        -e "s|\(#define CONST_SHARE_DIR \).*|\1\"$out/share\"|g" \
        -i include/ntop_defines.h
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "High-speed web-based traffic analysis and flow collection tool";
    homepage = "https://www.ntop.org/products/traffic-analysis/ntop/";
    changelog = "https://github.com/ntop/ntopng/blob/${finalAttrs.version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor ];
    mainProgram = "ntopng";
  };
})
