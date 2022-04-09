{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "swaysome";
  version = "1.1.2";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = pname;
    rev = version;
    sha256 = "sha256-eX2Pzn5It4yf94ZWH/7yAJjwpayVYvpvbrvk7qvbimg=";
  };

  cargoSha256 = "sha256-WXjmXwqeWnQVyFs51t81kHHMMn9HQQjBRw1g1cU+6/M=";

  meta = with lib; {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = licenses.mit;
    maintainers = with maintainers; [ esclear ];
  };
}
