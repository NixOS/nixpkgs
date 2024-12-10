{
  lib,
  fetchFromGitHub,
  buildGoModule,
  chromium,
}:

buildGoModule rec {
  pname = "wayback";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "wabarc";
    repo = "wayback";
    rev = "v${version}";
    hash = "sha256-LIWCT0/5T52VQQK4Dy6EFmFlJ02MkfvKddN/O/5zpZc=";
  };

  vendorHash = "sha256-TC4uwJswpD5oKqF/rpXqU/h+k0jErwhguT/LkdBA83Y=";

  doCheck = false;

  buildInputs = [
    chromium
  ];

  meta = with lib; {
    description = "An archiving tool with an IM-style interface";
    homepage = "https://docs.wabarc.eu.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _2gn ];
    # binary build for darwin is possible, but it requires chromium for runtime dependency, whose build (for nix) is not supported on darwin.
    platforms = platforms.linux;
  };
}
