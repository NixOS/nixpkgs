{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "libgen-cli";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "ciehanski";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EscXn+di1BXJSoc1Eml654/ieRuIOfryd5b7f+vcAOA=";
  };

  vendorHash = "sha256-WAGFZ2HKnhS5gStJW8orF45vsrHaTmUomzbHqFuAsFE=";

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    installShellCompletion --cmd libgen-cli \
      --bash <($out/bin/libgen-cli completion bash) \
      --fish <($out/bin/libgen-cli completion fish) \
      --zsh <($out/bin/libgen-cli completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/ciehanski/libgen-cli";
    description =
      "A CLI tool used to access the Library Genesis dataset; written in Go";
    longDescription = ''
      libgen-cli is a command line interface application which allows users to
      quickly query the Library Genesis dataset and download any of its
      contents.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ zaninime ];
    mainProgram = "libgen-cli";
  };
}
