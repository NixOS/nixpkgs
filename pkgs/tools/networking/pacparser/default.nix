{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pacparser";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "manugarg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qIfzAQ/dJgOZJajNU3XyFudSxu2w4JC0ffHosHXje1o=";
  };

  makeFlags = [ "NO_INTERNET=1" ];

  preConfigure = ''
    export makeFlags="$makeFlags PREFIX=$out"
    patchShebangs tests/runtests.sh
    cd src
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Library to parse proxy auto-config (PAC) files";
    homepage = "https://pacparser.manugarg.com/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "pactester";
  };
}
