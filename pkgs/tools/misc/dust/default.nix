{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dust";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "0z1vi5agaf1gcq1bdzgfc89v6vpk9kaxxy8f3rd2h6yzdrd2dhk7";
  };

  cargoSha256 = "08c428rrana0llzhkg8ngzqs6vc773jrf4wql2qxdvm4l0nsx596";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = https://github.com/bootandy/dust;
    license = licenses.asl20;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.all;
  };
}
