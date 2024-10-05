{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "aws-nuke";
  version = "3.26.0";

  src = fetchFromGitHub {
    owner = "ekristen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MwXFJYKSg6kjTuffOgsl2DIJKW8RMsfwApiYIKA+HWU=";
  };

  vendorHash = "sha256-foBVhvNH5Wh07eF1w3/dWmzXg1Dpm9IDm5PfBl1BGWQ=";

  nativeBuildInputs = [installShellFiles];

  overrideModAttrs = _: {
    preBuild = ''
      go generate ./...
    '';
  };

  doCheck = false;

  subPackages = ["."];

  ldflags = ["-s" "-w" "-extldflags=\"-static\""];

  postInstall = ''
    installShellCompletion --cmd aws-nuke \
      --bash <($out/bin/aws-nuke completion bash) \
      --fish <($out/bin/aws-nuke completion fish) \
      --zsh <($out/bin/aws-nuke completion zsh)
  '';

  meta = with lib; {
    description = "Nuke a whole AWS account and delete all its resources";
    homepage = "https://github.com/ekristen/aws-nuke";
    changelog = "https://github.com/ekristen/aws-nuke/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [grahamc];
    mainProgram = "aws-nuke";
  };
}
