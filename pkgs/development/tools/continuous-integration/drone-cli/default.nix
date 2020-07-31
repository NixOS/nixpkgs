{ stdenv, fetchFromGitHub, buildGoModule }:

let version = "1.2.1";
in buildGoModule rec {
  inherit version;
  pname = "drone-cli";
  revision = "v${version}";
  goPackagePath = "github.com/drone/drone-cli";

  vendorSha256 = "1zzx5yy0pp0c8pias4sfxfvdzhhrff9f8j51qf6dkif99xwdq3hb";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.version=${version}")
  '';

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = revision;
    sha256 = "19icihi5nxcafxlh4w61nl4cd0dhvik9zl8g4gqmazikjqsjms2j";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ bricewge ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server.";
  };
}
