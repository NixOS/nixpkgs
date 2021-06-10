{ stdenv, lib, fetchurl, unzip, ... }:

stdenv.mkDerivation rec {
  pname = "vikunja-frontend";
  version = "0.17.0";
  src = fetchurl {
    url = "https://dl.vikunja.io/frontend/${pname}-${version}.zip";
    sha256 = "sha256-LUYBCdEwDMwhFuIIRmnrtQN9ChaEZyFbItMxh27H5XY=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r * $out/

    runHook postInstall
  '';

  meta = {
    description = "Frontend of the Vikunja to-do list app";
    homepage = "https://vikunja.io/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ em0lar ];
    platforms = lib.platforms.all;
  };
}
