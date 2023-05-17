{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    hash = "sha256-P1KW9JUHzH/aK3wehVMSVJcUmMqDEGc8zVg8P6F828s=";
  };

  vendorSha256 = "sha256-+itNqxEy0S2g5UGpUIthJE2ILQzToISref/8F4zTmYg=";

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
