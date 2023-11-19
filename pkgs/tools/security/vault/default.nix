{ stdenv, lib, fetchFromGitHub, buildGoModule, installShellFiles, nixosTests
, makeWrapper
, gawk
, glibc
}:

buildGoModule rec {
  pname = "vault";
  version = "1.14.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "sha256-E7lEKsbl2L6KhLgAZbemCaTIjbsvl3wg3oCURn/Judc=";
  };

  vendorHash = "sha256-8ytAT7qVXAIfoeMyTBMJ6DiWn74sRM1WrrOYaKTlKMo=";

  proxyVendor = true;

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  tags = [ "vault" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/hashicorp/vault/sdk/version.GitCommit=${src.rev}"
    "-X github.com/hashicorp/vault/sdk/version.Version=${version}"
    "-X github.com/hashicorp/vault/sdk/version.VersionPrerelease="
  ];

  postInstall = ''
    echo "complete -C $out/bin/vault vault" > vault.bash
    installShellCompletion vault.bash
  '' + lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/vault \
      --prefix PATH ${lib.makeBinPath [ gawk glibc ]}
  '';

  passthru.tests = { inherit (nixosTests) vault vault-postgresql vault-dev vault-agent; };

  meta = with lib; {
    homepage = "https://www.vaultproject.io/";
    description = "A tool for managing secrets";
    changelog = "https://github.com/hashicorp/vault/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    mainProgram = "vault";
    maintainers = with maintainers; [ rushmorem lnl7 offline pradeepchhetri Chili-Man techknowlogick ];
  };
}
