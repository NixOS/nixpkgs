{ lib, stdenv, fetchurl, makeWrapper, jre_headless, gnused }:

stdenv.mkDerivation rec {
  pname = "ktlint";
  version = "0.47.1";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${version}/ktlint";
    sha256 = "sha256-ozOtAXI2mlzZc66oPgLotpjAai2qxvMpJdoDBJqj3Oc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/ktlint
  '';

  postFixup = ''
    wrapProgram $out/bin/ktlint --prefix PATH : "${lib.makeBinPath [ jre_headless gnused ]}"
  '';

  meta = with lib; {
    description = "An anti-bikeshedding Kotlin linter with built-in formatter";
    homepage = "https://ktlint.github.io/";
    license = licenses.mit;
    platforms = jre_headless.meta.platforms;
    maintainers = with maintainers; [ tadfisher SubhrajyotiSen ];
  };
}
