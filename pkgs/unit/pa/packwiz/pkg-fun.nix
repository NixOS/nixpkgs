{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packwiz";
  version = "unstable-2022-10-29";

  src = fetchFromGitHub {
    owner = "packwiz";
    repo = "packwiz";
    rev = "f00dc9844ffdd6ee5c0526a79b0084429e9cb130";
    sha256 = "sha256-YpihFWdcKfHJLEs+jHzHH7G+m/E8i5y2yp7IubObNhY=";
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
