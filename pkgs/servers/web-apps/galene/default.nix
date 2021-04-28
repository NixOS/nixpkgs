{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    sha256 = "1pl3mnkmfqykhq55q36kvvnvn9fgsk72pfa7nii3hywzad0bj0ar";
  };

  vendorSha256 = "0jrc6y5chkj25bnpzn6blvfb0vd09h6fdcz75g54605z8nqd397p";

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
