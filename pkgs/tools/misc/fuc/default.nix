{ lib
, rustPlatform
, fetchFromGitHub
, clippy
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "fuc";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    rev = version;
    hash = "sha256-Ii0X2QGvUE+wDD7pKN3Mws4VqnwGJFdpjjv3oJRn/pY=";
  };

  cargoHash = "sha256-08MQCKfkusnE9fuuJOlKeDESwmf8ajU7qMjujN2o5bU=";

  RUSTC_BOOTSTRAP = 1;

  cargoBuildFlags = [ "--workspace" "--bin cpz" "--bin rmz" ];

  nativeCheckInputs = [ clippy rustfmt ];

  meta = with lib; {
    description = "Modern, performance focused unix commands";
    homepage = "https://github.com/SUPERCILEX/fuc";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
