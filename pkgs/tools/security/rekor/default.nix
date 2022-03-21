{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

let
  generic = { pname, packageToBuild, description }:
    buildGoModule rec {
      inherit pname;
      version = "0.5.0";

      src = fetchFromGitHub {
        owner = "sigstore";
        repo = "rekor";
        rev = "v${version}";
        sha256 = "sha256-y8klkb0hyITxLhcNWF7RYRVwF8rclDKzQF/MJs6y//Y=";
      };

      vendorSha256 = "sha256-0PPdnE3ND/YNIk50XkgBROpe5OhFiFre5Lwsml02DQU=";

      nativeBuildInputs = [ installShellFiles ];

      subPackages = [ packageToBuild ];

      ldflags = [ "-s" "-w" "-X github.com/sigstore/rekor/pkg/api.GitVersion=v${version}" ];

      postInstall = ''
        installShellCompletion --cmd ${pname} \
          --bash <($out/bin/${pname} completion bash) \
          --fish <($out/bin/${pname} completion fish) \
          --zsh <($out/bin/${pname} completion zsh)
      '';

      meta = with lib; {
        inherit description;
        homepage = "https://github.com/sigstore/rekor";
        changelog = "https://github.com/sigstore/rekor/releases/tag/v${version}";
        license = licenses.asl20;
        maintainers = with maintainers; [ lesuisse jk ];
      };
    };
in {
  rekor-cli = generic {
    pname = "rekor-cli";
    packageToBuild = "cmd/rekor-cli";
    description = "CLI client for Sigstore, the Signature Transparency Log";
  };
  rekor-server = generic {
    pname = "rekor-server";
    packageToBuild = "cmd/rekor-server";
    description = "Sigstore server, the Signature Transparency Log";
  };
}
