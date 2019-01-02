{ stdenv, fetchFromGitHub, imagemagick, qrencode
, testQR ? false, zbar ? null
}:

assert testQR -> zbar != false;

stdenv.mkDerivation rec {
  name = "asc-key-to-qr-code-gif-${version}";
  version = "20180613";

  src = fetchFromGitHub {
    owner = "yishilin14";
    repo = "asc-key-to-qr-code-gif";
    rev = "5b7b239a0089a5269444cbe8a651c99dd43dce3f";
    sha256 = "0yrc302a2fhbzryb10718ky4fymfcps3lk67ivis1qab5kbp6z8r";
  };

  buildInputs = [ imagemagick qrencode ] ++ stdenv.lib.optional testQR zbar;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  preInstall = ''
    substituteInPlace asc-to-gif.sh \
      --replace "convert" "${imagemagick}/bin/convert" \
      --replace "qrencode" "${qrencode.bin}/bin/qrencode"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/yishilin14/asc-key-to-qr-code-gif;
    description = "Convert ASCII-armored PGP keys to animated QR code";
    platforms = platforms.linux;
    maintainers = with maintainers; [ asymmetric ];
  };
}
