{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "trashy";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "oberblastmeister";
    repo = "trashy";
    rev = "v${version}";
    sha256 = "sha256-xYSk0M8oNwbwZbKWDXMQlnt7vKi0p3+2Tr4eXCvtHEM=";
  };

  cargoSha256 = "sha256-ZWqWtWzb+CLH1ravBb/oV+aPxplEyiC1wEFhvchcLqg=";

  # this patch must be removed after oberblastmeister/trashy#70 is solved or new
  # version is released.
  cargoPatches = [ ./lock-version.patch ];

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
