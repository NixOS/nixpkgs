{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "minica";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "jsha";
    repo = "minica";
    rev = "v${version}";
    sha256 = "sha256-3p6rUFFiWXhX9BBbxqWxRoyRceexvNnqcFCyNi5HoaA=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A simple tool for generating self signed certificates";
    longDescription = ''
      Minica is a simple CA intended for use in situations where the CA operator
      also operates each host where a certificate will be used. It automatically
      generates both a key and a certificate when asked to produce a
      certificate.
    '';
    homepage = "https://github.com/jsha/minica/";
    changelog = "https://github.com/jsha/minica/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ m1cr0man ];
  };
}
