{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, stdenv}:

rustPlatform.buildRustPackage rec {
  pname = "gotify-desktop";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = pname;
    rev = version;
    sha256 = "sha256-EDLOSxmODC7OzVSZJxwKNnFA2yh+QKE8aXmYJ+Dnv40=";
  };

  cargoSha256 = "sha256-opSXndOjdmYG5DJ3CDUHWhN6O7AQp4Cleldzq1Hfr1o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Small Gotify daemon to send messages as desktop notifications";
    homepage = "https://github.com/desbma/gotify-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 genofire ];
    broken = stdenv.isDarwin;
  };
}
