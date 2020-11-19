{ stdenv, fetchFromGitHub, buildGoPackage, installShellFiles, nixosTests }:

buildGoPackage rec {
  pname = "vault";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "144v7vmp2amv29y6d50jzc21zrcw0g6qlwks16mvqy2hnbsnzdwa";
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
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem lnl7 offline pradeepchhetri ];
  };
}
