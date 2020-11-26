{ stdenv, lib, fetchFromGitHub, help2man, xrandr }:

stdenv.mkDerivation rec {
  pname = "mons";
  version = "20200320";

  src = fetchFromGitHub {
    owner = "Ventto";
    repo = pname;
    rev = "375bbba3aa700c8b3b33645a7fb70605c8b0ff0c";
    sha256 = "19r5y721yrxhd9jp99s29jjvm0p87vl6xfjlcj38bljq903f21cl";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ help2man ];
  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "POSIX Shell script to quickly manage 2-monitors display";
    homepage = "https://github.com/Ventto/mons.git";
    license = licenses.mit;
    maintainers = [ maintainers.mschneider ];
  };
}
