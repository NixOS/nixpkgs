{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "smug";
  version = "0.3.2";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "ivaaaan";
    repo = "smug";
    rev = "v${version}";
    sha256 = "sha256-JZV4UfrmvcM7d8Ld4m/jC3GvzJCUgXqsGBSSnz81fXk=";
  };

  vendorSha256 = "sha256-vaDUzVRmpmNn8/vUPeR1U5N6T4llFRIk9A1lum8uauU=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X=main.version=${version}" ];

  postInstall = ''
    installManPage ./man/man1/smug.1
    installShellCompletion completion/smug.{bash,fish}
  '';

  meta = with lib; {
    homepage = "https://github.com/ivaaaan/smug";
    description = "Smug - tmux session manager";
    license = licenses.mit;
    maintainers = with maintainers; [ juboba ];
  };
}
