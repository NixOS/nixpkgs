{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pacparser";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "manugarg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-p83aAcZ3fGOrokq4HDgF5/VxMl3Q11voSjdaBUUO4S0=";
  };

  makeFlags = [ "NO_INTERNET=1" ];

  preConfigure = ''
    export makeFlags="$makeFlags PREFIX=$out"
    patchShebangs tests/runtests.sh
    cd src
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "A library to parse proxy auto-config (PAC) files";
    homepage = "https://pacparser.manugarg.com/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
