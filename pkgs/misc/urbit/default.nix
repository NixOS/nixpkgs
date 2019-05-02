{ stdenv, fetchFromGitHub, curl, git, gmp, libsigsegv, meson, ncurses, ninja
, openssl, pkgconfig, re2c, zlib
}:

stdenv.mkDerivation rec {
  name = "urbit-${version}";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "urbit";
    repo = "urbit";
    rev = "v${version}";
    sha256 = "192843pjzh8z55fd0x70m3l1vncmixljia3nphgn7j7x4976xkp2";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ninja meson ];
  buildInputs = [ curl git gmp libsigsegv ncurses openssl re2c zlib ];

  postPatch = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "An operating function";
    homepage = https://urbit.org;
    license = licenses.mit;
    maintainers = with maintainers; [ mudri ];
    platforms = with platforms; linux;
  };
}
