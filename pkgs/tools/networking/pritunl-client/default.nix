{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pritunl-client";
  version = "1.3.3584.5";

  src = fetchFromGitHub {
    owner = "pritunl";
    repo = "pritunl-client-electron";
    rev = version;
    sha256 = "sha256-wWpP2u+oQSESjkRvAn5by7efvssYtKBYg2E+FZ/+tg0=";
  };

  modRoot = "cli";
  vendorHash = "sha256-miwGLWpoaavg/xcw/0pNBYCdovBnvjP5kdaaGPcRuWk=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/pritunl-client
    installShellCompletion --cmd pritunl-client \
      --bash <($out/bin/pritunl-client completion bash) \
      --fish <($out/bin/pritunl-client completion fish) \
      --zsh <($out/bin/pritunl-client completion zsh)
  '';

  meta = with lib; {
    description = "Pritunl OpenVPN client CLI";
    homepage = "https://github.com/pritunl/pritunl-client-electron/tree/master/cli";
    license = licenses.unfree;
    maintainers = with maintainers; [ minizilla ];
  };
}
