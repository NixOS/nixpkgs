{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, CoreServices
, cmake
, libiconv
, useMimalloc ? false
, doCheck ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2021-10-25";
  cargoSha256 = "sha256-PCQxXNpv4krdLBhyINoZT5QxV2hCqXpp1mqs0dUu4Ag=";

  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = version;
    sha256 = "sha256-3AMRwtEmITIvUdR/NINQTPatkjhmS1dQsbbsefIDYAE=";
  };

  patches = [
    # Code format and git history check require more dependencies but don't really matter for packaging.
    # So just ignore them.
    ./ignore-git-and-rustfmt-tests.patch
  ];

  # Revert edition 2021 related code since we have rust 1.55.0 in nixpkgs currently.
  # Remove them when we have rust >= 1.56.0
  # They change Cargo.toml so go `cargoPatches`.
  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/rust-analyzer/rust-analyzer/commit/f0ad6fa68bf98d317518bb75da01b7bb7abe98d3.patch";
      revert = true;
      sha256 = "sha256-ksX2j1Pgtd+M+FmXTEljm1nUxJwcY8GDQ9784Lb1uM4=";
    })
    (fetchpatch {
      url = "https://github.com/rust-analyzer/rust-analyzer/commit/8457ae34bdbca117b2ef73787b214161440e21f9.patch";
      revert = true;
      sha256 = "sha256-w1Py1bvZ2/tDQDZVMNmPRo6i6uA4H3YYZY4rXlo0iqg=";
    })
    (fetchpatch {
      url = "https://github.com/rust-analyzer/rust-analyzer/commit/ca44b6892e3e66765355d4e645f74df3d184c03b.patch";
      revert = true;
      sha256 = "sha256-N1TWlLxEg6oxFkns1ieVVvLAkrHq2WOr1tbkNvZvDFg=";
    })
    (fetchpatch {
      url = "https://github.com/rust-analyzer/rust-analyzer/commit/1294bfce865c556184c9327af4a8953ca940aec8.patch";
      revert = true;
      sha256 = "sha256-65eZxAjsuUln6lzSihIP26x15PELLDL4yk9wiVzJ0hE=";
    })
  ];

  buildAndTestSubdir = "crates/rust-analyzer";

  cargoBuildFlags = lib.optional useMimalloc "--features=mimalloc";
  cargoTestFlags = lib.optional useMimalloc "--features=mimalloc";

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
