{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "snooze";
  version = "0.5";
  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "snooze";
    rev = "v${version}";
    sha256 = "sha256-K77axli/mapUr3yxpmUfFq4iWwgRmEVUlP6+/0Iezwo=";
  };
  makeFlags = [ "DESTDIR=$(out)" "PREFIX=/" ];

  meta = with lib; {
    description = "Tool for waiting until a particular time and then running a command";
    maintainers = with maintainers; [ kaction ];
    license = licenses.cc0;
    platforms = platforms.unix;
    mainProgram = "snooze";
  };
}
