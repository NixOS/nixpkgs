{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ruff";
  version = "0.0.267";

  src = fetchFromGitHub {
    owner = "charliermarsh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-inbW+oobW0hAsNdvJoiHvKoKAUjcuhEUrJe7fh5c6go=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libcst-0.1.0" = "sha256-jG9jYJP4reACkFLrQBWOYH6nbKniNyFVItD0cTZ+nW0=";
      "ruff_text_size-0.0.0" = "sha256-rOk7N6YyMDiC/mn60Q5b3JGFvclj4ICbhYlpwNQsOiI=";
      "rustpython-literal-0.2.0" = "sha256-GBlD+oZpUxciPcBMw5Qq1sJoZqs4RwjZ+W53M3CqdAc=";
      "unicode_names2-0.6.0" = "sha256-eWg9+ISm/vztB0KIdjhq5il2ZnwGJQCleCYfznCI3Wg=";
    };
  };

  patches = [
    # without this patch, cargo-vendor-dir fails with the following error:
    # ln: failed to create symbolic link '...-rustpython-literal-0.2.0': Permission denied
    # this patch removes dependencies with the same name and fixes the conflict
    # https://github.com/charliermarsh/ruff/pull/4388
    (fetchpatch {
      name = "use-new-rustpython-format-crate-over-rustpython-common.patch";
      url = "https://github.com/charliermarsh/ruff/commit/10eb4a38e86449fae023fbb591ffc16efec85bc8.patch";
      hash = "sha256-bIun+Ge0bh4te0ih3bQtwRWJGi1h0weiLaN1AOhXR6E=";
    })
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  cargoBuildFlags = [ "--package=ruff_cli" ];
  cargoTestFlags = cargoBuildFlags;

  preBuild = lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    # See https://github.com/jemalloc/jemalloc/issues/1997
    # Using a value of 48 should work on both emulated and native x86_64-darwin.
    export JEMALLOC_SYS_WITH_LG_VADDR=48
  '';

  postInstall = ''
    installShellCompletion --cmd ruff \
      --bash <($out/bin/ruff generate-shell-completion bash) \
      --fish <($out/bin/ruff generate-shell-completion fish) \
      --zsh <($out/bin/ruff generate-shell-completion zsh)
  '';

  meta = with lib; {
    description = "An extremely fast Python linter";
    homepage = "https://github.com/charliermarsh/ruff";
    changelog = "https://github.com/charliermarsh/ruff/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
