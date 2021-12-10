{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    sha256 = "sha256-J4a2uBjwVmHlvliqyRZo1LOvEvhU32IXb8Z38x+kQ6E=";
  };

  vendorSha256 = "sha256-VxoPScXHV6x6GdtyKnC3W/CoAHSJSuyJJdfzXSpkPAA=";

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
