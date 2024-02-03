{ lib
, rustPlatform
, fetchFromGitHub
, clippy
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "fuc";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "fuc";
    rev = version;
    hash = "sha256-4yksr2gilR7Ec2sRzGsGmOgbRSQJR/5fDofZM4sRxDg=";
  };

  cargoHash = "sha256-U/LABtCtpop+MXAceE93FKtf1FfgLuVIYqqXtd0NckQ=";

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
