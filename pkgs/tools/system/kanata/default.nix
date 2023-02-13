{ fetchFromGitHub
, lib
, rustPlatform
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mQSbsJ+3mKoDMg0ewwR7UvXUq+5WA9aTPKWCaTz8nDE=";
  };

  cargoHash = "sha256-fFxgM305UROpPiOjwxCt+Hq8g6/JqXq/bUmx2V952WQ=";

  buildFeatures = lib.optional withCmd "cmd";

  meta = with lib; {
    description = "A tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ linj ];
    platforms = platforms.linux;
  };
}
