{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "ferium";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "gorilla-devs";
    repo = pname;
    rev = "v${version}";
    sha256 = "5DYdeK6JdA7oLBkjP3WkwLwlBitdf4Yt2dNP7P0INN0=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "7rpxHfe+pWarPJ72WSXjgr63YctZ5+RrsEgmw7o66VI=";

  buildNoDefaultFeatures = true; # by default pulls in GTK 3 just for its directory picker

  doCheck = false; # requires internet

  meta = with lib; {
    description = "A CLI Minecraft mod manager for mods from Modrinth, CurseForge, and Github Releases";
    homepage = "https://github.com/theRookieCoder/ferium";
    license = licenses.mpl20;
    maintainers = [ maintainers.leo60228 ];
  };
}
