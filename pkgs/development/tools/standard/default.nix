{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "standard";
  version = "17.1.0";

  src = fetchFromGitHub {
    owner = "standard";
    repo = "standard";
    rev = "v${version}";
    hash = "sha256-paLvnwXOeTC4SSc+j/LhMLd4j8FgRa1QzGg6bxtlvTs=";
  };

  npmDepsHash = "sha256-Bfyu2XeJwbBiIevuNKSdeg7SO5j3Typgb+bIHZJSi7k=";

  makeCacheWritable = true;

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmFlags = [ "--legacy-peer-deps" ];

  meta = with lib; {
    description = "JavaScript Style Guide, with linter & automatic code fixer";
    homepage = "https://github.com/standard/standard";
    changelog =
      "https://github.com/standard/standard/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
