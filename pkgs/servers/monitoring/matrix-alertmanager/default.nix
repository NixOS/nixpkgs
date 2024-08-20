{ lib
, buildNpmPackage
, fetchFromGitHub
, jq
}:

buildNpmPackage rec {
  pname = "matrix-alertmanager";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "jaywink";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7rsY/nUiuSVkM8fbPPa9DB3c+Uhs+Si/j1Jzls6d2qc=";
  };

  postPatch = ''
    ${lib.getExe jq} '. += {"bin": "src/app.js"}' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-OI/zlz03YQwUnpOiHAVQfk8PWKsurldpp0PbF1K9zbM=";

  dontNpmBuild = true;

  meta = with lib; {
    changelog = "https://github.com/jaywink/matrix-alertmanager/blob/${src.rev}/CHANGELOG.md";
    description = "Bot to receive Alertmanager webhook events and forward them to chosen rooms";
    mainProgram = "matrix-alertmanager";
    homepage = "https://github.com/jaywink/matrix-alertmanager";
    license = licenses.mit;
    maintainers = [ ];
  };
}
