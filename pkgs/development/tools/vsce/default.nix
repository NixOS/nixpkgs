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
  version = "2.20.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    rev = "v${version}";
    hash = "sha256-wwSrECqCNBTfr+Hk0sO6eI64uXCiJuRdCk7HUf5oO4g=";
  };

  npmDepsHash = "sha256-eTyeNvI34+x2ymyQc3qD5WTGIwL+7OjUCK3u2QZhJDQ=";

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
