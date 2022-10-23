{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, pkg-config
, libsecret
, python3
, testers
, vsce
}:

buildNpmPackage rec {
  pname = "vsce";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    rev = "v${version}";
    hash = "sha256-rMKH+98Ml/7NsSJIUCCOrxF6MnY2kgKoXaJ1reayy0M=";
  };

  npmDepsHash = "sha256-sKCghsHjvbwdnbod/vX72S1pDq4xHSlKbX8W8hg+cpY=";

  postPatch = ''
    substituteInPlace package.json --replace '"version": "0.0.0"' '"version": "${version}"'
  '';

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libsecret ];

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

