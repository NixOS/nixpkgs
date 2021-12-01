{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "minica";
  version = "1.0.2";

  goPackagePath = "github.com/jsha/minica";

  src = fetchFromGitHub {
    owner = "jsha";
    repo = "minica";
    rev = "v${version}";
    sha256 = "18518wp3dcjhf3mdkg5iwxqr3326n6jwcnqhyibphnb2a58ap7ny";
  };

  ldflags = [
    "-X main.BuildVersion=${version}"
  ];

  meta = with lib; {
    description = "A simple tool for generating self signed certificates";
    longDescription = ''
      Minica is a simple CA intended for use in situations where the CA
      operator also operates each host where a certificate will be used. It
      automatically generates both a key and a certificate when asked to
      produce a certificate.
    '';
    homepage = "https://github.com/jsha/minica/";
    license = licenses.mit;
    maintainers = with maintainers; [ m1cr0man ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
