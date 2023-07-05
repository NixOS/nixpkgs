{ lib, stdenv, fetchFromGitHub
, glibc, python3
}:

stdenv.mkDerivation rec {
  pname = "0xtools";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "tanelpoder";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pe64st3yhVfZi8/sTEfH1cNjx7JpqxDmxMmodpXnqaU=";
  };

  postPatch = ''
    substituteInPlace lib/0xtools/proc.py \
      --replace /usr/include/asm/unistd_64.h ${glibc.dev}/include/asm/unistd_64.h
  '';

  buildInputs = [ python3 ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Utilities for analyzing application performance";
    homepage = "https://0x.tools";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ astro ];
    platforms = [ "x86_64-linux" ];
  };
}
