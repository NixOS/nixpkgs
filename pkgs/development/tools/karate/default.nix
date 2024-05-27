{ lib, stdenvNoCC, fetchurl, jre, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "karate";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/karatelabs/karate/releases/download/v${version}/karate-${version}.jar";
    sha256 = "sha256-3gNoXUchrfGkZC6UAfw2TXorzSlqnOZCe0gnuUHIIb4=";
  };
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    makeWrapper ${jre}/bin/java $out/bin/karate --add-flags "-jar $src"
    runHook postInstall
  '';

  meta = with lib; {
    description = "API Test Automation Made Simple";
    mainProgram = "karate";
    longDescription = ''
      Karate is the only open-source tool to combine API
      test-automation, mocks, performance-testing and even UI
      automation into a single, unified framework. The BDD syntax
      popularized by Cucumber is language-neutral, and easy for even
      non-programmers. Assertions and HTML reports are built-in, and
      you can run tests in parallel for speed.
    '';
    homepage = "https://github.com/karatelabs/karate";
    changelog = "https://github.com/karatelabs/karate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.kephasp ];
    platforms = jre.meta.platforms;
  };
}
