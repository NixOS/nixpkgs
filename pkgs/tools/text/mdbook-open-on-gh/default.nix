{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    hash = "sha256-73738Vei7rQ67LQIOrHPGOtsBnHClaXClRWDmA5pP58=";
  };

  cargoHash = "sha256-TQBjgQaoI88xGdhkffNWRH6aZ99WWbkkpiPu4LqBD3g=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    mainProgram = "mdbook-open-on-gh";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
