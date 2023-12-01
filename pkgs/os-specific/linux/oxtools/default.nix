{ lib, stdenv, fetchFromGitHub
, glibc, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "0xtools";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "tanelpoder";
    repo = "0xtools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h0/HIbwb1CvFUh/NpozDUCjYGCH647lC7JhbpDCvaLk=";
  };

  postPatch = ''
    substituteInPlace lib/0xtools/psnproc.py \
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
})
