{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "ferium";
  version = "4.1.5";

  src = fetchFromGitHub {
    owner = "gorilla-devs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NxrV8mi7xsr+x9oOp78DkHoPls0JLm5eol/8q9NwuTs=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-hR2PKQqSvtSBOOhZKW2IsGGjuU4jCdLMeruAHxErQtU=";

  buildNoDefaultFeatures = true; # by default pulls in GTK 3 just for its directory picker

  doCheck = false; # requires internet

  meta = with lib; {
    description = "A CLI Minecraft mod manager for mods from Modrinth, CurseForge, and Github Releases";
    homepage = "https://github.com/theRookieCoder/ferium";
    license = licenses.mpl20;
    maintainers = [ maintainers.leo60228 ];
  };
}
