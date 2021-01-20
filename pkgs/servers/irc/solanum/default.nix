{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, bison
, flex
, openssl
, sqlite
, lksctp-tools
}:

stdenv.mkDerivation rec {
  pname = "solanum";
  version = "unstable-2020-12-14";

  src = fetchFromGitHub {
    owner = "solanum-ircd";
    repo = pname;
    rev = "551e5a146eab4948ce4a57d87a7f671f2d7cc02d";
    sha256 = "14cd2cb04w6nwck7q49jw5zvifkzhkmblwhjfskc2nxcdb5x3l96";
  };

  patches = [
    ./dont-create-logdir.patch
  ];

  configureFlags = [
    "--enable-epoll"
    "--enable-ipv6"
    "--enable-openssl=${openssl.dev}"
    "--with-program-prefix=solanum-"
    "--localstatedir=/var/lib/solanum"
    "--with-rundir=/run/solanum"
    "--with-logdir=/var/log/solanum"
  ] ++ lib.optionals (stdenv.isLinux) [
    "--enable-sctp=${lksctp-tools.out}/lib"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "An IRCd for unified networks";
    homepage = "https://github.com/solanum-ircd/solanum";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.unix;
  };
}
