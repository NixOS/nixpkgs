{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, pkg-config
, libsecret
<<<<<<< HEAD
, darwin
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, python3
, testers
, vsce
}:

buildNpmPackage rec {
  pname = "vsce";
<<<<<<< HEAD
  version = "2.21.0";
=======
  version = "2.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-iBbKVfkmt8n06JJ8TSO8BDCeiird9gTkOQhlREtZ5Cw=";
  };

  npmDepsHash = "sha256-Difk9a9TYmfwzP9SawEuaxm7iHVjdfO+FxFCE7aEMzM=";
=======
    hash = "sha256-WDKOHQV6J22l0ELmXwl5BC5x7MsI6TAMeU3oBFpwqx4=";
  };

  npmDepsHash = "sha256-i2LpQ/4MwkUGTUhih0ybLv5np45j7m4kCx9IOBIgtXo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    substituteInPlace package.json --replace '"version": "0.0.0"' '"version": "${version}"'
  '';

  nativeBuildInputs = [ pkg-config python3 ];

<<<<<<< HEAD
  buildInputs = [ libsecret ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ AppKit Security ]);
=======
  buildInputs = [ libsecret ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
