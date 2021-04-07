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

  patches = [
    # Substitute xrandr path with @xrandr@ so we can replace it with
    # real path in substituteInPlace
    ./xrandr.patch
  ];

  postPatch = ''
    substituteInPlace mons.sh --replace '@xrandr@' '${xrandr}/bin/xrandr'
  '';

  nativeBuildInputs = [ help2man ];
  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "POSIX Shell script to quickly manage 2-monitors display";
    homepage = "https://github.com/Ventto/mons.git";
    license = licenses.mit;
    maintainers = with maintainers; [ mschneider thiagokokada ];
  };
}
