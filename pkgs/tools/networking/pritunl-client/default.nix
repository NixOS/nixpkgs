{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pritunl-client";
  version = "1.3.3343.50";

  src = fetchFromGitHub {
    owner = "pritunl";
    repo = "pritunl-client-electron";
    rev = version;
    sha256 = "sha256-xooTPJFtCIIQG8cibfqxGDTIzF2vjvmo8zteVNiHsGQ=";
  };

  modRoot = "cli";
  vendorSha256 = "sha256-fI2RIzvfbqBgchsvY8hsiecXYItM2XX9h8oiP3zmfTA=";

  postInstall = ''
    mv $out/bin/cli $out/bin/pritunl-client
  '';

  meta = with lib; {
    description = "Pritunl OpenVPN client CLI";
    homepage = "https://github.com/pritunl/pritunl-client-electron/tree/master/cli";
    license = licenses.unfree;
    maintainers = with maintainers; [ bigzilla ];
  };
}
