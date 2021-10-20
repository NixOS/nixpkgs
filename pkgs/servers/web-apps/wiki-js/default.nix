{ stdenv, fetchurl, lib, nixosTests }:

stdenv.mkDerivation rec {
  pname = "wiki-js";
  version = "2.5.219";

  src = fetchurl {
    url = "https://github.com/Requarks/wiki/releases/download/${version}/${pname}.tar.gz";
    sha256 = "sha256-xzxOv17B+9wegtNXGr9SD4KUWlMbrvPtZhvfmoZhBNc=";
  };

  sourceRoot = ".";

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r . $out

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) wiki-js; };

  meta = with lib; {
    homepage = "https://js.wiki/";
    description = "A modern and powerful wiki app built on Node.js";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ma27 ];
  };
}
