{ stdenv, fetchFromGitHub, buildGoModule, Security }:

buildGoModule rec {
  pname = "drone-cli";
  version = "1.2.1";

  modSha256 = "0g0vq4vm2hy00r2gjsrhg57xv9sldlqix3wzimiqdli085bcz46b";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.version=${version}")
  '';

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = "v${version}";
    sha256 = "19icihi5nxcafxlh4w61nl4cd0dhvik9zl8g4gqmazikjqsjms2j";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ bricewge ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server.";
  };
}
