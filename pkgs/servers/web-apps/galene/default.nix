{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    hash = "sha256-wklWAs5Ag9FZu85vLPNXoiS7TVQe98fLbRiMIp2OsaI=";
  };

  vendorHash = "sha256-U8DH3b2KbFQbEV+7suVsBiTA42FEl6DebH+GJDaH6aE=";

  ldflags = [ "-s" "-w" ];
  preCheck = "export TZ=UTC";

  outputs = [ "out" "static" ];

  postInstall = ''
    mkdir $static
    cp -r ./static $static
  '';

  meta = with lib; {
    description = "Videoconferencing server that is easy to deploy, written in Go";
    homepage = "https://github.com/jech/galene";
    changelog = "https://github.com/jech/galene/raw/galene-${version}/CHANGES";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rgrunbla erdnaxe ];
  };
}
