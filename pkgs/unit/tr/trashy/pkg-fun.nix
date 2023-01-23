{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "trashy";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "oberblastmeister";
    repo = "trashy";
    rev = "v${version}";
    sha256 = "sha256-b50Q7knJzXKDfM1kw6wLvXunhgOXVs+zYvZx/NYqMdk=";
  };

  cargoSha256 = "sha256-2hNNLXuAHd1bquhHimniqryTVMfBmPAOossggICScqQ=";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    installShellCompletion --cmd trash \
      --bash <($out/bin/trash completions bash) \
      --fish <($out/bin/trash completions fish) \
      --zsh <($out/bin/trash completions zsh) \
  '';

  meta = with lib; {
    description = "A simple, fast, and featureful alternative to rm and trash-cli.";
    homepage = "https://github.com/oberblastmeister/trashy";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ oberblastmeister ];
  };
}
