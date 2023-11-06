{ stdenv, lib, fetchurl, unzip, nixosTests, ... }:

stdenv.mkDerivation rec {
  pname = "vikunja-frontend";
  version = "0.21.0";

  src = fetchurl {
    url = "https://dl.vikunja.io/frontend/${pname}-${version}.zip";
    hash = "sha256-7FnY24B2EjAoMxFnNXBQ9zvbW0F5PPXEfWCs+fH93BI=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r * $out/

    runHook postInstall
  '';

  passthru.tests.vikunja = nixosTests.vikunja;

  meta = {
    changelog = "https://kolaente.dev/vikunja/frontend/src/tag/v${version}/CHANGELOG.md";
    description = "Frontend of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ leona ];
    platforms = lib.platforms.all;
  };
}
