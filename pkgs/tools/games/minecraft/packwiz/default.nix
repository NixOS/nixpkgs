{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packwiz";
  version = "unstable-2022-08-25";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "11671421acff9794b9ca5c7e083a514f8a3f55a4";
    sha256 = "sha256-A+DVRi0YByF4WP/okqhWrKRmci2ybAvbXYmODScIrYg=";
  };

  vendorSha256 = "sha256-09S8RFdCvtE50EICLIKCTnTjG/0XsGf+yq9SNObKmRA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd packwiz \
      --bash <($out/bin/packwiz completion bash) \
      --fish <($out/bin/packwiz completion fish) \
      --zsh <($out/bin/packwiz completion zsh)
  '';

  meta = with lib; {
    description = "A command line tool for editing and distributing Minecraft modpacks, using a git-friendly TOML format";
    homepage = "https://packwiz.infra.link/";
    license = licenses.mit;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "packwiz";
  };
}
