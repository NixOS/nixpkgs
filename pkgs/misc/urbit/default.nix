{ autoconf, automake, cmake, curl, fetchFromGitHub, gcc, git, gmp, libsigsegv,
  libtool, meson, ncurses, ninja, openssl, pkgconfig, python2, ragel, re2c,
  stdenv, zlib }:

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

  buildInputs = with stdenv.lib; [
    autoconf automake cmake curl gcc git gmp libsigsegv libtool
    meson ncurses ninja openssl pkgconfig python2 ragel re2c zlib
  ];

  # uses 'readdir_r' deprecated by glibc 2.24
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  configurePhase = ''
    :
  '';

  postPatch = ''
    patchShebangs .
    substituteInPlace scripts/build --replace 'meson .' 'meson --prefix $out .'
  '';

  buildPhase = ''
    git init .
    ./scripts/bootstrap
    ./scripts/build
    ninja -C ./build/ install
  '';

  installPhase = ''
    :
  '';

  meta = with stdenv.lib; {
    description = "An operating function";
    homepage = https://urbit.org;
    license = licenses.mit;
    maintainers = with maintainers; [ mudri ];
    platforms = with platforms; linux;
  };
}
