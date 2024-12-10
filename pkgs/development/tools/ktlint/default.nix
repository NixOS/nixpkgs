{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
  gnused,
}:

stdenv.mkDerivation rec {
  pname = "ktlint";
  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${version}/ktlint";
    sha256 = "sha256:14pbjih8gkh5cp9cqpbciml4ba7nvq5vmvivyrmhff3xq93cya1f";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/ktlint
  '';

  postFixup = ''
    wrapProgram $out/bin/ktlint --prefix PATH : "${
      lib.makeBinPath [
        jre_headless
        gnused
      ]
    }"
  '';

  meta = with lib; {
    description = "An anti-bikeshedding Kotlin linter with built-in formatter";
    homepage = "https://ktlint.github.io/";
    license = licenses.mit;
    platforms = jre_headless.meta.platforms;
    changelog = "https://github.com/pinterest/ktlint/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [
      tadfisher
      SubhrajyotiSen
    ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    mainProgram = "ktlint";
  };
}
