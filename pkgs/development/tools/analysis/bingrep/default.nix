{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bingrep";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M3BYj1SKQKjEqP9cxaVlh7UeleDbcx6JN+UI6Ez+QJ8=";
  };

  cargoHash = "sha256-botAoLNg/qTh+cjPXcjo/Ol2Vktj/c5130k5falEuLY=";

  meta = with lib; {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    homepage = "https://github.com/m4b/bingrep";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
