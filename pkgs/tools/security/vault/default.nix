{ stdenv, lib, fetchFromGitHub, buildGoModule, installShellFiles, nixosTests
, makeWrapper
, gawk
, glibc
}:

buildGoModule rec {
  pname = "vault";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "sha256-bYZghlQi2p3XnKWH3H2sehds/XSMW8pbzBophNMa5q4=";
  };

  vendorHash = "sha256-mNnStWxrSR455zGWkj4dLDFk/kdOXYgk8LKB0wy7K5M=";

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

  passthru.tests = { inherit (nixosTests) vault vault-postgresql vault-dev; };

  meta = with lib; {
    homepage = "https://www.vaultproject.io/";
    description = "A tool for managing secrets";
    changelog = "https://github.com/hashicorp/vault/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem lnl7 offline pradeepchhetri Chili-Man techknowlogick ];
  };
}
