{ lib
, buildNpmPackage
, fetchurl
, nodejs
, testers
, yarn-lock-converter
}:

let
  source = lib.importJSON ./source.json;
in
buildNpmPackage rec {
  pname = "yarn-lock-converter";
  inherit (source) version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@vht/yarn-lock-converter/-/yarn-lock-converter-${version}.tgz";
    hash = "sha256-CP1wI33fgtp4GSjasktbfWuUjGzCuK3XR+p64aPAryQ=";
  };

  npmDepsHash = source.deps;

  dontBuild = true;

  nativeBuildInputs = [ nodejs ];

  postPatch = ''
    # Use generated package-lock.json as upstream does not provide one
    ln -s ${./package-lock.json} package-lock.json
  '';

  postInstall = ''
    mv $out/bin/@vht/yarn-lock-converter $out/bin/yarn-lock-converter
    rmdir $out/bin/@vht
  '';
  passthru = {
    tests.version = testers.testVersion {
      package = yarn-lock-converter;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Converts modern Yarn v2+ yarn.lock files into a Yarn v1 format";
    homepage = "https://github.com/VHT/yarn-lock-converter";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
    mainProgram = "yarn-lock-converter";
  };
}
