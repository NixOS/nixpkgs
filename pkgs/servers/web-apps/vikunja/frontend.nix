{ stdenv, lib, fetchurl, unzip, nixosTests, ... }:

stdenv.mkDerivation rec {
  pname = "vikunja-frontend";
  version = "0.19.0";
  src = fetchurl {
    url = "https://dl.vikunja.io/frontend/${pname}-${version}.zip";
    sha256 = "sha256-pdUNPfGgbSMyXcS2HKMekIiIzJ3GutHCs0gFVkHN9yc=";
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
    maintainers = with lib.maintainers; [ leona ];
    platforms = lib.platforms.all;
  };
}
