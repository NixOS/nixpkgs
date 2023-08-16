{ lib
, buildNpmPackage
, fetchFromGitHub
, jq
}:

buildNpmPackage rec {
  pname = "matrix-alertmanager";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "jaywink";
    repo = pname;
    rev = "v${version}";
    sha256 = "M3/8viRCRiVJGJSHidP6nG8cr8wOl9hMFY/gzdSRN+4=";
  };

  postPatch = ''
    ${lib.getExe jq} '. += {"bin": "src/app.js"}' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-hR9Q/8sLxSf916BARBgTKmwonv5JqSSkfvOfYL9SdeU=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Bot to receive Alertmanager webhook events and forward them to chosen rooms";
    homepage = "https://github.com/jaywink/matrix-alertmanager";
    license = licenses.mit;
    maintainers = with maintainers; [ yuka ];
  };
}
