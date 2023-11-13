{ buildGoModule
, fetchFromGitHub
, makeWrapper
, lib
, openssh
, testers
, vault-ssh-plus
}:
buildGoModule rec {
  pname = "vault-ssh-plus";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "isometry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t987QIMXrG+p+mmRnVrYnhvsmkqCFe/qe1AEtzKArnY=";
  };

  vendorHash = "sha256-VUsy4z1kIK6TDb5RYNwgDsoqjO6bsTNrXVMO7IXkjO4=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/vault-ssh-plus $out/bin/vssh
    wrapProgram $out/bin/vssh --prefix PATH : ${lib.makeBinPath [ openssh ]};
  '';

  passthru.tests.version = testers.testVersion {
    package = vault-ssh-plus;
    command = "vssh --version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/isometry/vault-ssh-plus";
    changelog = "https://github.com/isometry/vault-ssh-plus/releases/tag/v${version}";
    description = "Automatically use HashiCorp Vault SSH Client Key Signing with ssh(1)";
    license = licenses.mit;
    maintainers = with maintainers; [ lesuisse ];
  };
}
