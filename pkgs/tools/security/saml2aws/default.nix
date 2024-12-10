{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  AppKit,
}:

buildGoModule rec {
  pname = "saml2aws";
  version = "2.36.15";

  src = fetchFromGitHub {
    owner = "Versent";
    repo = "saml2aws";
    rev = "v${version}";
    sha256 = "sha256-lfA+D3NsrnYwqX1hfC3TOQKEBW/65QGUjzYxe2RVVSM=";
  };

  vendorHash = "sha256-3jne2an651tlyXgmmQ28R/bwsfaQzI4rC+4WJhyDA2E=";

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];

  subPackages = [
    "."
    "cmd/saml2aws"
  ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "CLI tool which enables you to login and retrieve AWS temporary credentials using a SAML IDP";
    mainProgram = "saml2aws";
    homepage = "https://github.com/Versent/saml2aws";
    license = licenses.mit;
    maintainers = [ lib.maintainers.pmyjavec ];
  };
}
