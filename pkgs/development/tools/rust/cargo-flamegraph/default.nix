{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  perf,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flamegraph";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "flamegraph-rs";
    repo = "flamegraph";
    rev = "v${version}";
    sha256 = "sha256-JGUABNCZhDyTTrjFCRsT+wkuAeZn9mCHCI6XgGYEl7Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-FjLjEoorbZC2WZ424w2aFLmd4dIfy5s13sR8BSRVNIo=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
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
