{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "swaysome";
  version = "1.1.4";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = pname;
    rev = version;
    sha256 = "sha256-hI6XPND05m67dxo9EwIDhFTyC2UrL4Ll1V/WcBoJymU=";
  };

  cargoSha256 = "sha256-jG6HZiL2almALyEnQRmbeCTRG11URP3+Bxqyn8hLs7w=";

  meta = with lib; {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = licenses.mit;
    maintainers = with maintainers; [ esclear ];
  };
}
