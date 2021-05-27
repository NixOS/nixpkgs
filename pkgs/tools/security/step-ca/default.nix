{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "step-ca";
  version = "0.15.15";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    rev = "v${version}";
    sha256 = "sha256-YYYpMHEis/zoRsdwW70X8zn0FMsW+2vMYdlWxr3qqzY=";
  };

  vendorSha256 = "sha256-mjj+70/ioqcchB3X5vZPb0Oa7lA/qKh5zEpidT0jrEs=";

  preBuild = ''
    export CGO_ENABLED=0
  '';

  meta = with lib; {
    description = "A private certificate authority (X.509 & SSH) & ACME server for secure automated certificate management, so you can use TLS everywhere & SSO for SSH";
    homepage = "https://smallstep.com/certificates/";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
