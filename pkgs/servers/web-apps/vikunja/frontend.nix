{ stdenv, lib, fetchurl, unzip, nixosTests, ... }:

stdenv.mkDerivation rec {
  pname = "vikunja-frontend";
  version = "0.18.1";
  src = fetchurl {
    url = "https://dl.vikunja.io/frontend/${pname}-${version}.zip";
    sha256 = "sha256-u4XA6Jqn+p2J0sB2KabwZY/lFwZakZEvUUh/enrhtN4=";
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
    description = "Frontend of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ em0lar ];
    platforms = lib.platforms.all;
  };
}
