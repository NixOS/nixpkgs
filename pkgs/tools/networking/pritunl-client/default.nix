{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pritunl-client";
  version = "1.3.3467.51";

  src = fetchFromGitHub {
    owner = "pritunl";
    repo = "pritunl-client-electron";
    rev = version;
    sha256 = "sha256-US1A3PjWxycXzOW/1Mi8GVkxvH6xCFq4mo5gU49vytU=";
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
    maintainers = with maintainers; [ bigzilla ];
  };
}
