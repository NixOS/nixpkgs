{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pritunl-client";
  version = "1.3.3484.2";

  src = fetchFromGitHub {
    owner = "pritunl";
    repo = "pritunl-client-electron";
    rev = version;
    sha256 = "sha256-thIbw/Iek2vNNmkOBHrzEhTbaOm05CsbjqORQKC2jIs=";
  };

  modRoot = "cli";
  vendorHash = "sha256-miwGLWpoaavg/xcw/0pNBYCdovBnvjP5kdaaGPcRuWk=";

  postInstall = ''
    mv $out/bin/cli $out/bin/pritunl-client
  '';

  meta = with lib; {
    description = "Pritunl OpenVPN client CLI";
    homepage = "https://github.com/pritunl/pritunl-client-electron/tree/master/cli";
    license = licenses.unfree;
    maintainers = with maintainers; [ minizilla ];
  };
}
