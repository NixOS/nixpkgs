{ lib
, stdenv
, fetchFromGitHub
, imagemagick
, makeWrapper
, qrencode
}:

stdenv.mkDerivation {
  pname = "asc-key-to-qr-code-gif";
  version = "20200304";

  src = fetchFromGitHub {
    owner = "yishilin14";
    repo = "asc-key-to-qr-code-gif";
    rev = "5b7b239a0089a5269444cbe8a651c99dd43dce3f";
    sha256 = "0yrc302a2fhbzryb10718ky4fymfcps3lk67ivis1qab5kbp6z8r";
  };

  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 asc-to-gif.sh -t $out/bin

    wrapProgram $out/bin/asc-to-gif.sh \
      --prefix PATH ":" ${lib.makeBinPath [ imagemagick qrencode ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/yishilin14/asc-key-to-qr-code-gif";
    description = "Convert ASCII-armored PGP keys to animated QR code";
    platforms = platforms.unix;
    maintainers = with maintainers; [ asymmetric ];
  };
}
