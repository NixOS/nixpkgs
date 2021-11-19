{ lib, stdenv, fetchFromGitHub, autoreconfHook, zlib, lzo, bzip2, lz4, nasm, perl }:

stdenv.mkDerivation rec {
  pname = "lrzip";
  version = "0.641";

  src = fetchFromGitHub {
    owner = "ckolivas";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-253CH6TiHWyr13C76y9PXjyB7gj2Bhd2VRgJ5r+cm/g=";
  };

  nativeBuildInputs = [ autoreconfHook nasm perl ];

  buildInputs = [ zlib lzo bzip2 lz4 ];

  configureFlags = [
    "--disable-asm"
  ];

  meta = with lib; {
    homepage = "http://ck.kolivas.org/apps/lrzip/";
    description = "The CK LRZIP compression program (LZMA + RZIP)";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
