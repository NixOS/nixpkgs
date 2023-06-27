{ lib, stdenv, fetchurl, makeWrapper, jre_headless, gnused }:

stdenv.mkDerivation rec {
  pname = "ktlint";
  version = "0.49.1";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${version}/ktlint";
    sha256 = "1k2byxqvgr2xll4jj0ck8w3qdgkvjhwkag18inxjakcl99knygrb";
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
  };
}
