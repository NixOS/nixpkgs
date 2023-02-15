{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    hash = "sha256-MO+tadm20qG5NtIXaWxDRiX7l+m7t0QRK/9IK7qA0bo=";
  };

  cargoHash = "sha256-X113sexUgLOsrXXO2p+qNFT2XcEy9AGPvVEf3bxqH8g=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
