{ fetchFromGitHub
, lib
, rustPlatform
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2gGFAz0zXea+27T4ayDj6KdoI0ThwXV7U0CspHduTiQ=";
  };

  cargoHash = "sha256-0NvZATdPABIboL5xvmBmDbqPPWvO4mM6wVB3FrOVHIQ=";

  buildFeatures = lib.optional withCmd "cmd";

  meta = with lib; {
    description = "A tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ linj ];
    platforms = platforms.linux;
  };
}
