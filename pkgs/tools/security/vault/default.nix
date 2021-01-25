{ stdenv, fetchFromGitHub, buildGoPackage, installShellFiles, nixosTests }:

buildGoPackage rec {
  pname = "vault";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "1pgyyl2zgnr3wy4k8c5xsk2s5dpl97xdfq67lpfss7fz1bij8x47";
  };

  goPackagePath = "github.com/hashicorp/vault";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [ "-tags=vault" "-ldflags=-s -w -X ${goPackagePath}/sdk/version.GitCommit=${src.rev}" ];

  postInstall = ''
    echo "complete -C $out/bin/vault vault" > vault.bash
    installShellCompletion vault.bash
  '';

  passthru.tests.vault = nixosTests.vault;

  meta = with stdenv.lib; {
    homepage = "https://www.vaultproject.io/";
    description = "A tool for managing secrets";
    changelog = "https://github.com/hashicorp/vault/blob/v${version}/CHANGELOG.md";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem lnl7 offline pradeepchhetri ];
  };
}
