{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sJINgB1cGtqLPl2RmwgChwnSrJL5TWu5AU6hfLhvmE4=";
  };

  cargoHash = "sha256-HrmqARhEKlAjrW6QieVEEKkfda6R69oLcG/6fd3rvWM=";

  patches = [
    # tests make the assumption that the compiled binary is in target/debug,
    # which fails since `cargoBuildHook` uses `--release` and `--target`
    (fetchpatch {
      name = "fix-tests-with-release-or-target";
      url = "https://github.com/sigoden/argc/commit/a4f2db46e27cad14d3251ef0b25b6f2ea9e70f0e.patch";
      hash = "sha256-bsHSo11/RVstyzdg0BKFhjuWUTLdKO4qsWIOjTTi+HQ=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd argc \
      --bash <($out/bin/argc --argc-completions bash) \
      --fish <($out/bin/argc --argc-completions fish) \
      --zsh <($out/bin/argc --argc-completions zsh)
  '';

  meta = with lib; {
    description = "A command-line options, arguments and sub-commands parser for bash";
    homepage = "https://github.com/sigoden/argc";
    changelog = "https://github.com/sigoden/argc/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
