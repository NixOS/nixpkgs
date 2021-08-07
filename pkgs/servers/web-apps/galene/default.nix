{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    sha256 = "sha256-yb+gEex4WEvIAEMuSTkw25rsBTL9tlfhf9qQtISWUd0=";
  };

  vendorSha256 = "sha256-Vm7tTTQJyZZVbORl5ziy4GJ34kHh5dh0ojX/ZuTpshA=";

  outputs = [ "out" "static" ];

  postInstall = ''
    mkdir $static
    cp -r ./static $static
  '';

  meta = with lib; {
    description = "Videoconferencing server that is easy to deploy, written in Go";
    homepage = "https://github.com/jech/galene";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rgrunbla ];
  };
}
