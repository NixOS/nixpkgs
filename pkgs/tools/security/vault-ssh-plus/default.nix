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
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "isometry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-djS50SBR8HTyEd5Ya2I9w5irBrLTqzekEi5ASmkl6yk=";
  };

  vendorHash = "sha256-NndIBvW1/EZJ2KwP6HZ6wvhrgtmhTe97l3VxprtWq30=";

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
    mainProgram = "vssh";
    license = licenses.mit;
    maintainers = with maintainers; [ lesuisse ];
  };
}
