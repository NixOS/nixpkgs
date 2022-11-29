{ fetchFromGitHub
, lib
, rustPlatform
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9x0ELoYCwfE0N7CuxZYMPBmX8A5Vh4pAtbcY6X6S9eQ=";
  };

  cargoHash = "sha256-e7yftR1mLMllBe0OIU5QWmGtQm+h30CbTInB6ojQk7M=";

  buildFeatures = lib.optional withCmd "cmd";

  meta = with lib; {
    description = "A tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ linj ];
    platforms = platforms.linux;
  };
}
