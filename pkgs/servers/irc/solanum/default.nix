{ lib, stdenv
, autoreconfHook
, bison
, fetchFromGitHub
, flex
, lksctp-tools
, openssl
, pkg-config
, sqlite
, util-linux
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "solanum";
  version = "unstable-2022-07-12";

  src = fetchFromGitHub {
    owner = "solanum-ircd";
    repo = pname;
    rev = "860187d02895fc953de3475da07a7a06b9380254";
    hash = "sha256-g8hXmxTfcPDmQ/cu4AI/iJfrhPLaQJEAeMdDhNDsVXs=";
  };

  patches = [
    ./dont-create-logdir.patch
  ];

  postPatch = ''
    substituteInPlace include/defaults.h --replace 'ETCPATH "' '"/etc/solanum'
  '';

  configureFlags = [
    "--enable-epoll"
    "--enable-ipv6"
    "--enable-openssl=${openssl.dev}"
    "--with-program-prefix=solanum-"
    "--localstatedir=/var/lib"
    "--with-rundir=/run"
    "--with-logdir=/var/log"
  ] ++ lib.optionals (stdenv.isLinux) [
    "--enable-sctp=${lksctp-tools.out}/lib"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
    util-linux
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;
  # Missing install depends:
  #   ...-binutils-2.40/bin/ld: cannot find ./.libs/libircd.so: No such file or directory
  #   collect2: error: ld returned 1 exit status
  #   make[4]: *** [Makefile:634: solanum] Error 1
  enableParallelInstalling = false;

  passthru.tests = { inherit (nixosTests) solanum; };

  meta = with lib; {
    description = "IRCd for unified networks";
    homepage = "https://github.com/solanum-ircd/solanum";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.unix;
  };
}
