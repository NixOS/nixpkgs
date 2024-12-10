{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
}:

stdenv.mkDerivation rec {
  pname = "wmutils-libwm";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "wmutils";
    repo = "libwm";
    rev = "v${version}";
    sha256 = "1lpbqrilhffpzc0b7vnp08jr1wr96lndwc7y0ck8hlbzlvm662l0";
  };

  buildInputs = [ libxcb ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A small library for X window manipulation";
    homepage = "https://github.com/wmutils/libwm";
    license = licenses.isc;
    maintainers = with maintainers; [ bhougland ];
    platforms = platforms.unix;
  };
}
