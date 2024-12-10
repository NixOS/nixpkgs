{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "bore-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "bore";
    rev = "v${version}";
    hash = "sha256-fHCWK/GI/MDbBPCpkgKJlWjFEsl8Ey6IdUZQPnYUfjg=";
  };

  cargoHash = "sha256-/k/7/mCD0abspPr+GGk/8ovnWl85OsmJtzirmfVxDNo=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  # tests do not find grcov path correctly
  meta = with lib; {
    description = "Rust tool to create TCP tunnels";
    homepage = "https://github.com/ekzhang/bore";
    license = licenses.mit;
    maintainers = with maintainers; [ DieracDelta ];
    mainProgram = "bore";
  };
}
