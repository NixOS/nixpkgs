{ lib, stdenv, fetchurl, makeWrapper, jre_headless, gnused }:

stdenv.mkDerivation rec {
  pname = "ktlint";
<<<<<<< HEAD
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${version}/ktlint";
    sha256 = "1pc1ck87l849xfy1lcdr1v3p84qyxn9725pvh09czvlqs58yy6ax";
=======
  version = "0.49.0";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${version}/ktlint";
    sha256 = "1vm064b591lp5yygryz0p0zdfwlp1nhl5dv2nzx0y92j3911q0yz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/pinterest/ktlint/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [ tadfisher SubhrajyotiSen ];
<<<<<<< HEAD
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
