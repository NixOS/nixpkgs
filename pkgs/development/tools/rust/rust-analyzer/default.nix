{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, cmake, fetchpatch
, libiconv
, useMimalloc ? false
, doCheck ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2021-05-17";
  cargoSha256 = "sha256-uSBukInJ3FEMmMpG9DN3XeXm+hzUFqCrZORb4NIEJhw=";

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = version;
    sha256 = "sha256-BsabpY4LArfsDPAMsggxKu1+OQZmqRe//+a5uBcuFps=";
  };

  patches = [
    # Revert updates which require rust 1.52.0.
    # We currently have rust 1.51.0 in nixpkgs.
    # https://github.com/rust-analyzer/rust-analyzer/pull/8718
    (fetchpatch {
      url = "https://github.com/rust-analyzer/rust-analyzer/pull/8718/commits/607d8a2f61e56fabb7a3bc5132592917fcdca970.patch";
      sha256 = "sha256-g1yyq/XSwGxftnqSW1bR5UeMW4gW28f4JciGvwQ/n08=";
      revert = true;
    })
    (fetchpatch {
      url = "https://github.com/rust-analyzer/rust-analyzer/pull/8718/commits/6a16ec52aa0d91945577c99cdf421b303b59301e.patch";
      sha256 = "sha256-n7Ew/0fG8zPaMFCi8FVLjQZwJSaczI/QoehC6pDLrAk=";
      revert = true;
    })
  ];

  buildAndTestSubdir = "crates/rust-analyzer";

  cargoBuildFlags = lib.optional useMimalloc "--features=mimalloc";

  nativeBuildInputs = lib.optional useMimalloc cmake;

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreServices
    libiconv
  ];

  RUST_ANALYZER_REV = version;

  inherit doCheck;
  preCheck = lib.optionalString doCheck ''
    export RUST_SRC_PATH=${rustPlatform.rustLibSrc}
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    versionOutput="$($out/bin/rust-analyzer --version)"
    echo "'rust-analyzer --version' returns: $versionOutput"
    [[ "$versionOutput" == "rust-analyzer ${version}" ]]
    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "An experimental modular compiler frontend for the Rust language";
    homepage = "https://github.com/rust-analyzer/rust-analyzer";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ oxalica ];
  };
}
