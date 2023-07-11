{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B0oN5qYCShIsSvMFJB5EJPWOWM3Ubn8jl2gm+l5Wqg0=";
  };

  cargoHash = "sha256-50ETDUKbK4oeVm9Ox44WVrAH5EAdH9F+sQk0WBTEQmY=";

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
