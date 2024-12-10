{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  perf,
  nix-update-script,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flamegraph";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "flamegraph-rs";
    repo = "flamegraph";
    rev = "v${version}";
    sha256 = "sha256-VrC3c3a1G8mn9U6txeynsaWOL4HQQk2IOiQqS52iPGo=";
  };

  cargoSha256 = "sha256-KwpveTiViY+C4A+fE5yeGuT9PXbDyi+YsOc75mX2KdU=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ];
  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/cargo-flamegraph \
      --set-default PERF ${perf}/bin/perf
    wrapProgram $out/bin/flamegraph \
      --set-default PERF ${perf}/bin/perf
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Easy flamegraphs for Rust projects and everything else, without Perl or pipes <3";
    homepage = "https://github.com/flamegraph-rs/flamegraph";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      killercup
      matthiasbeyer
    ];
  };
}
