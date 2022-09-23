{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "2.2.0";
    sha256 = "sha256-x7ESuXoF5dYnJZpgDyYliVixCG4w/VX/Vhm3VqxsiEI=";
  };

  cargoSha256 = "sha256-FVcCzL0jJ827HHS/9G597QjNFY3HLNYHCPWcepEulD0=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
