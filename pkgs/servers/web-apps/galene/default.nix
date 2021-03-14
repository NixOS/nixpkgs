{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "galene";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene";
    rev = "galene-${version}";
    sha256 = "0hpgqqv8mp1d3sk7dk49m3yv0cv4afa0v3vdd4w8mdnx6pcqdgy1";
  };

  vendorSha256 = "12b7andpzsgzmd56gg4gc5ilkxvjrpwpmwbdmygfzgkd5jncmcgp";

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
