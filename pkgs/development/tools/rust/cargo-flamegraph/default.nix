{ lib, stdenv, fetchFromGitHub, rustPlatform, makeWrapper, perf, nix-update-script
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flamegraph";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "flamegraph-rs";
    repo = "flamegraph";
    rev = "v${version}";
    sha256 = "sha256-yeNA6HkhWEUqarBDRbyD3RBIlBZZVrbAMng7d5beBB4=";
  };

  cargoSha256 = "sha256-IHOVaRfjopaSRY8HF8ATdNNLfhTVrIKvYsAuocqRdWI=";

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
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ killercup matthiasbeyer ];
  };
}
