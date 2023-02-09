{ lib
, fetchFromGitHub
, buildGoModule
, pandoc
, installShellFiles
, nix-update-script
, testers
, eget
}:

buildGoModule rec {
  pname = "eget";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tUHA5LbTOz20ydMM8141VjCUBsxI+Wzkgfh27aq/2y4=";
  };

  vendorSha256 = "sha256-J8weaJSC+k8BnijG2Jm2GYUZmEhASrrCDxb46ZGmCMI=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  nativeBuildInputs = [ pandoc installShellFiles ];

  postInstall = ''
    pandoc man/eget.md -s -t man -o eget.1
    installManPage eget.1
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = eget;
      command = "eget -v";
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Easily install prebuilt binaries from GitHub";
    homepage = "https://github.com/zyedidia/eget";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
