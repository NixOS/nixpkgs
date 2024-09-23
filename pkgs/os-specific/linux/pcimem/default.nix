{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pcimem";
  version = "unstable-2018-08-29";

  src = fetchFromGitHub {
    owner = "billfarrow";
    repo = pname;
    rev = "09724edb1783a98da2b7ae53c5aaa87493aabc9b";
    sha256 = "0zlbvcl5q4hgna11p3w00px1p8qgn8ga79lh6a2m7d597g86kbq3";
  };

  outputs = [ "out" "doc" ];

  makeFlags = [ "CFLAGS=-Wno-maybe-uninitialized" ];

  installPhase = ''
    install -D pcimem "$out/bin/pcimem"
    install -D README "$doc/doc/README"
  '';

  meta = with lib; {
    description = "Simple method of reading and writing to memory registers on a PCI card";
    mainProgram = "pcimem";
    homepage = "https://github.com/billfarrow/pcimem";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mafo ];
  };
}
