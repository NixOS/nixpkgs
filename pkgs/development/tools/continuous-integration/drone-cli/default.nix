{ stdenv, fetchFromGitHub, buildGoModule }:

let version = "1.2.2";
in buildGoModule rec {
  inherit version;
  pname = "drone-cli";
  revision = "v${version}";

  vendorSha256 = "1ryh94cj37j8x6qwxr5ydyw6cnjppakg1w84sipm11d0vvv98bhi";

  doCheck = false;

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.version=${version}")
  '';

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = revision;
    sha256 = "082yqm72y8s3v06gkcg947p62sd63y3r2bmdsrfgdrzb5w5a75bl";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ bricewge ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
