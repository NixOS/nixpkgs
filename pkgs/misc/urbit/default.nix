{ curl, fetchFromGitHub, gcc, git, gmp, libsigsegv, meson, ncurses, ninja,
  openssl, pkgconfig, re2c, stdenv, zlib }:

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

  nativeBuildInputs = [ pkgconfig ninja meson ];

  buildInputs = with stdenv.lib; [
    curl gcc git gmp libsigsegv ncurses openssl re2c zlib
  ];

  # uses 'readdir_r' deprecated by glibc 2.24
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postPatch = ''
    patchShebangs .
  '';

  mesonFlags = [
    "--buildtype=release"
  ];

  meta = with stdenv.lib; {
    description = "An operating function";
    homepage = https://urbit.org;
    license = licenses.mit;
    maintainers = with maintainers; [ mudri ];
    platforms = with platforms; linux;
  };
}
