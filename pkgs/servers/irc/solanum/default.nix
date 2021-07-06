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
  version = "unstable-2021-04-27";

  src = fetchFromGitHub {
    owner = "solanum-ircd";
    repo = pname;
    rev = "3ff5a12e75662e9a642f2a4364797bd361eb0925";
    sha256 = "14ywmfdv8cncbyg08y2qdis00kwg8lvhkcgj185is67smh0qf88f";
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
