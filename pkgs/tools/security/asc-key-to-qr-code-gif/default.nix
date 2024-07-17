{
  lib,
  stdenv,
  fetchFromGitHub,
  imagemagick,
  qrencode,
  testQR ? false,
  zbar ? null,
}:

assert testQR -> zbar != false;

stdenv.mkDerivation {
  pname = "asc-key-to-qr-code-gif";
  version = "20180613";

  src = fetchFromGitHub {
    owner = "yishilin14";
    repo = "asc-key-to-qr-code-gif";
    rev = "5b7b239a0089a5269444cbe8a651c99dd43dce3f";
    sha256 = "0yrc302a2fhbzryb10718ky4fymfcps3lk67ivis1qab5kbp6z8r";
  };

  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  preInstall =
    let
      substitutions =
        [
          ''--replace "convert" "${imagemagick}/bin/convert"''
          ''--replace "qrencode" "${qrencode.bin}/bin/qrencode"''
        ]
        ++ lib.optionals testQR [
          ''--replace "hash zbarimg" "true"'' # hash does not work on NixOS
          ''--replace "$(zbarimg --raw" "$(${zbar.out}/bin/zbarimg --raw"''
        ];
    in
    ''
      substituteInPlace asc-to-gif.sh ${lib.concatStringsSep " " substitutions}
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/yishilin14/asc-key-to-qr-code-gif";
    description = "Convert ASCII-armored PGP keys to animated QR code";
    mainProgram = "asc-to-gif.sh";
    platforms = platforms.unix;
    maintainers = with maintainers; [ asymmetric ];
  };
}
