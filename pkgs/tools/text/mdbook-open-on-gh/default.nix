{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    hash = "sha256-K7SkfUxav/r8icrpdfnpFTSZdYV9qUEvYZ2dGSbaP0w=";
  };

  cargoHash = "sha256-Uvg0h0s3xtv/bVjqWLldvM/R5HQ6yoHdnBXvpUp/E3A=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
