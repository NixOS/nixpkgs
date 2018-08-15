{ stdenv, fetchFromGitHub, curl, gcc, gmp, libsigsegv, libtool, libuv, ncurses,
  openssl, perl, python2, ragel, re2c, zlib,
  pkgconfig, meson, ninja
}:

stdenv.mkDerivation rec {
  name = "urbit-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "urbit";
    repo = "urbit";
    rev = "urbit-${version}";
    sha256 = "158mz6c6y5z1b6piid8hvrl5mcqh8q1ny185gz51jayia51azmgs";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = with stdenv.lib; [
    curl
    gcc
    gmp
    libsigsegv
    libtool
    libuv
    ncurses
    openssl
    perl
    python2
    ragel
    re2c
    zlib
  ];

  # uses 'readdir_r' deprecated by glibc 2.24
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  configurePhase = ''
    :
  '';

  buildPhase = ''
    mkdir -p "$out/bin"
    meson . "$out/bin" --buildtype=release
    ninja -C "$out/bin"
  '';

  installPhase = ''
    :
  '';

  meta = with stdenv.lib; {
    description = "An operating function";
    homepage = http://urbit.org;
    license = licenses.mit;
    maintainers = with maintainers; [ mudri ];
    platforms = with platforms; linux;
  };
}
