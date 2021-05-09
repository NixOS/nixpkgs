{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    sha256 = "sha256-8CgNMI7zOeDxrnmQNDM61Bgpw+N0sc7HR9c+YsQTO5I=";
  };

  vendorSha256 = "sha256-qOHuZGMr0CPwy/DuuWYCDSe24Y6ivg1uQJGXCuKGV/M=";

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
