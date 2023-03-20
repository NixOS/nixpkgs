{ lib
, buildNpmPackage
, fetchurl
, testers
, mongosh
}:

let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
buildNpmPackage {
  pname = "mongosh";
  inherit (source) version;

  src = fetchurl {
    url = "https://registry.npmjs.org/mongosh/-/${source.filename}";
    hash = source.integrity;
  };

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = source.deps;

  makeCacheWritable = true;
  dontNpmBuild = true;
  npmFlags = [ "--omit=optional" ];

  passthru = {
    tests.version = testers.testVersion {
      package = mongosh;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://www.mongodb.com/try/download/shell";
    description = "The MongoDB Shell";
    maintainers = with maintainers; [ aaronjheng ];
    license = licenses.asl20;
    mainProgram = "mongosh";
  };
}
