{ lib, stdenv, fetchurl, makeWrapper, jre_headless, gnused }:

stdenv.mkDerivation rec {
  pname = "ktlint";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${version}/ktlint";
    sha256 = "sha256-AbLg74kzg6UNvrE5cP5/o742yj6DJZ4BZJlFsJ1zaYU=";
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
    description = "Anti-bikeshedding Kotlin linter with built-in formatter";
    homepage = "https://ktlint.github.io/";
    license = licenses.mit;
    platforms = jre_headless.meta.platforms;
    changelog = "https://github.com/pinterest/ktlint/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [ tadfisher SubhrajyotiSen ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    mainProgram = "ktlint";
  };
}
