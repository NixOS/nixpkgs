{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "doom-bcc-git-0.8.0.2018.01.04";

  src = fetchFromGitHub {
    owner = "wormt";
    repo = "bcc";
    rev = "d58b44d9f18b28fd732c27113e5607a454506d19";
    sha256 = "1m83ip40ln61qrvb1fbgaqbld2xip9n3k817lwkk1936pml9zcrq";
  };

  enableParallelBuilding = true;
  makeFlags = ["CC=cc"];

  patches = [ ./bcc-warning-fix.patch ];

  installPhase = ''
    mkdir -p $out/{bin,lib,share/doc}
    install -m755 bcc $out/bin/bcc
    cp -av doc $out/share/doc/bcc
    cp -av lib $out/lib/bcc
  '';

  meta = with lib; {
    description = "Compiler for Doom/Hexen scripts (ACS, BCS)";
    homepage = "https://github.com/wormt/bcc";
    license = licenses.mit;
    maintainers = with maintainers; [ertes];
  };
}
