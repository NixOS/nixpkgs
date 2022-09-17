{ stdenv, fetchurl, lib, nixosTests }:

stdenv.mkDerivation rec {
  pname = "wiki-js";
  version = "2.5.286";

  src = fetchurl {
    url = "https://github.com/Requarks/wiki/releases/download/v${version}/${pname}.tar.gz";
    sha256 = "sha256-jxnWUSvTldaIX21PryZiR4UlWmxs03gcGohOmnyDGS8=";
  };

  sourceRoot = ".";

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r . $out

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) wiki-js; };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://js.wiki/";
    description = "A modern and powerful wiki app built on Node.js";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ma27 ];
  };
}
