{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dust";
  version = "0.4.1.2";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "0a2n96p6z4y09l5z617qbpm8lgxvfagd1l950d2gz9xw4xf1ik5w";
  };

  cargoSha256 = "0cpgxkgz10na90r3fgz8hs20vihqdcc8983inn71fq90627bhdx7";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = https://github.com/bootandy/dust;
    license = licenses.asl20;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.all;
  };
}
