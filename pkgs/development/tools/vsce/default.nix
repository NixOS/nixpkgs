{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, pkg-config
, libsecret
, darwin
, python3
, testers
, vsce
}:

buildNpmPackage rec {
  pname = "vsce";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    rev = "v${version}";
    hash = "sha256-zpZ/PsqZ9yRDKTXkSrcBgSxYer7JdjNZqsseHwfzkEY=";
  };

  npmDepsHash = "sha256-Difk9a9TYmfwzP9SawEuaxm7iHVjdfO+FxFCE7aEMzM=";

  postPatch = ''
    substituteInPlace package.json --replace '"version": "0.0.0"' '"version": "${version}"'
  '';

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libsecret ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ AppKit Security ]);

  makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  passthru.tests.version = testers.testVersion {
    package = vsce;
  };

  meta = with lib; {
    homepage = "https://github.com/microsoft/vscode-vsce";
    description = "Visual Studio Code Extension Manager";
    maintainers = with maintainers; [ aaronjheng ];
    license = licenses.mit;
  };
}
