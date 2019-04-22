{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "shadowfox";
  version = "1.7.20";

  src = fetchFromGitHub {
    owner = "SrKomodo";
    repo = "shadowfox-updater";
    rev = "v${version}";
    sha256 = "14crips12l4n050b8hrqkfqbxl0l8s3y4y9lm8n0bjpxdpjbpr7q";
  };

  goPackagePath = "github.com/SrKomodo/shadowfox-updater";

  modSha256 = "143ky1fj7xglhjyzh78qzgh1m4j53kqps25c9vnq9q4vdyzm93sr";

  buildFlags = "--tags release";

  meta = with stdenv.lib; {
    description = ''
      This project aims at creating a universal dark theme for Firefox while
      adhering to the modern design principles set by Mozilla.
    '';
    homepage = "https://overdodactyl.github.io/ShadowFox/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ infinisil ];
  };
}
