{ stdenv, lib, fetchFromGitHub, buildGoModule, installShellFiles, nixosTests
, makeWrapper
, gawk
, glibc
}:

buildGoModule rec {
  pname = "vault-ssh-helper";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault-ssh-helper";
    rev = "v${version}";
    sha256 = "sha256-TY+0EqQW2vUh6JIDHI+98leOwBT9ZhsVTJL0FpZrXjo=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  tags = [ "vault-ssh-helper" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/hashicorp/vault-ssh-helper/sdk/version.GitCommit=${src.rev}"
    "-X github.com/hashicorp/vault-ssh-helper/sdk/version.Version=${version}"
    "-X github.com/hashicorp/vault-ssh-helper/sdk/version.VersionPrerelease="
  ];

  postInstall = ''
    echo "complete -C $out/bin/vault-ssh-helper vault-ssh-helper" > vault-ssh-helper.bash
    installShellCompletion vault-ssh-helper.bash
  '' + lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/vault-ssh-helper \
      --prefix PATH ${lib.makeBinPath [ gawk glibc ]}
  '';

  passthru.tests = { inherit (nixosTests) vault-ssh-helper; };

  meta = with lib; {
    description = "Vault SSH Agent is used to enable one time keys and passwords ";
    homepage = "https://github.com/hashicorp/vault-ssh-helper";
    license = licenses.mpl20;
    changelog = "https://github.com/hashicorp/vault-ssh-helper/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ lpostula ];
  };
}
