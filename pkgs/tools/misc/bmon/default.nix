{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, ncurses, libconfuse
, libnl }:

stdenv.mkDerivation rec {
  pname = "bmon";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "tgraf";
    repo = "bmon";
    rev = "v${version}";
    sha256 = "1ilba872c09mnlvylslv4hqv6c9cz36l76q74rr99jvis1dg69gf";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ ncurses libconfuse ] ++ lib.optional stdenv.isLinux libnl;

  preConfigure = ''
    # Must be an absolute path
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

  meta = with lib; {
    description = "Network bandwidth monitor";
    homepage = "https://github.com/tgraf/bmon";
    # Licensed unter BSD and MIT
    #  - https://github.com/tgraf/bmon/blob/master/LICENSE.BSD
    #  - https://github.com/tgraf/bmon/blob/master/LICENSE.MIT
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor pSub ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
