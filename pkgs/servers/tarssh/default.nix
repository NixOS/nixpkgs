{ fetchFromGitHub, rustPlatform, lib }:

with rustPlatform;

buildRustPackage rec {
  pname = "tarssh";
  version = "0.5.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Freaky";
    repo = pname;
    sha256 = "1waxfbw9lqbqv8igb291pjqg22324lzv4p7fsdfrkvxf95jd2i03";
  };

  cargoSha256 = "1f3anrh2y8yg7l4nilwk0a7c7kq5yvg07cqh75igjdb5a7p9di0j";

  meta = with lib; {
    description = "A simple SSH tarpit inspired by endlessh";
    homepage = "https://github.com/Freaky/tarssh";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ sohalt ];
    platforms = platforms.unix ;
  };
}
