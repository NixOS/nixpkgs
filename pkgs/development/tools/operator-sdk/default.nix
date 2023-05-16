{ lib
, buildGoModule
, go
, fetchFromGitHub
, makeWrapper
}:

buildGoModule rec {
  pname = "operator-sdk";
<<<<<<< HEAD
  version = "1.31.0";
=======
  version = "1.28.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-v/7nqZg/lwiK2k92kQWSZCSjEZhTAQHCGBcTfxQX2r0=";
  };

  vendorHash = "sha256-geKWTsDLx5drTleTnneg2JIbe5sMS5JUQxTX9Bcm+IQ=";
=======
    hash = "sha256-YzkPAKwkV8io0lz7JxIX4lciv85iqldkyitrLicbFJc=";
  };

  vendorHash = "sha256-ZWOIF3vmtoXzdGHHzjPy/351bHzMTTXcgSRBso+ixyM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    go
  ];

  doCheck = false;

  subPackages = [
    "cmd/ansible-operator"
    "cmd/helm-operator"
    "cmd/operator-sdk"
  ];

  # operator-sdk uses the go compiler at runtime
  allowGoReference = true;

  postFixup = ''
    wrapProgram $out/bin/operator-sdk --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = with lib; {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding";
    homepage = "https://github.com/operator-framework/operator-sdk";
    changelog = "https://github.com/operator-framework/operator-sdk/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnarg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
