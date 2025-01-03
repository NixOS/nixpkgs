{
  lib,
  stdenv,
  autoreconfHook,
  bison,
  fetchFromGitHub,
  flex,
  lksctp-tools,
  openssl,
  pkg-config,
  sqlite,
  util-linux,
  unstableGitUpdater,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "solanum";
  version = "0-unstable-2024-07-24";

  src = fetchFromGitHub {
    owner = "solanum-ircd";
    repo = "solanum";
    rev = "4e89f6603d63b2f8dfdec7a83161fb0343236349";
    hash = "sha256-kUgB0Q+U6jx8Xyh1DSv8D7+Q9tC2wK3aaNt4At5chFQ=";
  };

  patches = [
    ./dont-create-logdir.patch
  ];

  postPatch = ''
    substituteInPlace include/defaults.h --replace 'ETCPATH "' '"/etc/solanum'
  '';

  configureFlags =
    [
      "--enable-epoll"
      "--enable-ipv6"
      "--enable-openssl=${openssl.dev}"
      "--with-program-prefix=solanum-"
      "--localstatedir=/var/lib"
      "--with-rundir=/run"
      "--with-logdir=/var/log"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux) [
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

  doCheck = !stdenv.hostPlatform.isDarwin;

  enableParallelBuilding = true;
  # Missing install depends:
  #   ...-binutils-2.40/bin/ld: cannot find ./.libs/libircd.so: No such file or directory
  #   collect2: error: ld returned 1 exit status
  #   make[4]: *** [Makefile:634: solanum] Error 1
  enableParallelInstalling = false;

  passthru = {
    tests = { inherit (nixosTests) solanum; };
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "IRCd for unified networks";
    homepage = "https://github.com/solanum-ircd/solanum";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.unix;
  };
}
