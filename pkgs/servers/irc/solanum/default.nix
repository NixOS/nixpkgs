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
}:

stdenv.mkDerivation rec {
  pname = "solanum";
  version = "unstable-2021-11-14";

  src = fetchFromGitHub {
    owner = "solanum-ircd";
    repo = pname;
    rev = "bd38559fedcdfded4d9acbcbf988e4a8f5057eeb";
    sha256 = "sha256-2P+mqf5b+TD9+9dLahXOdH7ZZhPWUoR1eV73YHbRbAA=";
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

  meta = with lib; {
    description = "An IRCd for unified networks";
    homepage = "https://github.com/solanum-ircd/solanum";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.unix;
  };
}
