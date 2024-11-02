{ lib, stdenv, fetchFromGitHub, autoreconfHook, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "bgpdump";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = "bgpdump";
    rev = "v${version}";
    sha256 = "sha256-1HXMf9mHManR7jhonU2Agon0YFXOlM9APIN1Zm840AM=";
  };

  postPatch = ''
    substituteInPlace Makefile.in --replace 'ar r libbgpdump.a' '$(AR) r libbgpdump.a'
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib bzip2 ];

  meta = {
    homepage = "https://github.com/RIPE-NCC/bgpdump";
    description = "Analyze dump files produced by Zebra/Quagga or MRT";
    license = lib.licenses.hpnd;
    maintainers = with lib.maintainers; [ lewo ];
    platforms = with lib.platforms; linux;
    mainProgram = "bgpdump";
  };
}
