{ fetchFromGitHub
, lib
, rustPlatform
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/v3P5C0F/FVPJqJ38dzSnAc7ua2fOs3BeX9BDoQ8bDw=";
  };

  cargoHash = "sha256-KXsW0fgbBy0tf/He0vH9Xq8yGuz77H/jeIabgw3ppy8=";

  buildFeatures = lib.optional withCmd "cmd";

  meta = with lib; {
    description = "A tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ linj ];
    platforms = platforms.linux;
  };
}
