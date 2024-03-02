{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    hash = "sha256-UWh55+9+5s31VwRb7oOzOPKv9Ew7AxsOjWXaFRxuans=";
  };

  vendorHash = "sha256-MEO6ktMrpvuWBPBgpBRAuIrup4Zc8IQKoJ/6JEnD6+U=";

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
