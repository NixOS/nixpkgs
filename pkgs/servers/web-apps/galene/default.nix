{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    hash = "sha256-CeyxeZPvClKxjEU5GYqZzV2SCyHNAktHNQbmN9wUa+4=";
  };

  vendorHash = "sha256-NT6bNVoh26I4z/QUSJWwF5YDuzf3LUc/7OQgtslc4ME=";

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
