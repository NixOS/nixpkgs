{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  version = "2020-12-17";
  pname = "woof";

  src = fetchFromGitHub {
    owner = "simon-budig";
    repo = "woof";
    rev = "4aab9bca5b80379522ab0bdc5a07e4d652c375c5";
    sha256 = "0ypd2fs8isv6bqmlrdl2djgs5lnk91y1c3rn4ar6sfkpsqp9krjn";
  };

  propagatedBuildInputs = [ python3 ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/woof $out/bin/woof
    chmod +x $out/bin/woof
  '';

  meta = with lib; {
    homepage = "http://www.home.unix-ag.org/simon/woof.html";
    description = "Web Offer One File - Command-line utility to easily exchange files over a local network";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

