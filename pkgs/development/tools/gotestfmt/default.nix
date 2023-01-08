{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gotestfmt";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "gotesttools";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Rb/nIsHISzvqd+jJU4TNrHbailvgGEq4y0JuM9IdA3w=";
  };

  vendorHash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  meta = with lib; {
    description = "Go test output for humans";
    homepage = "https://github.com/gotesttools/gotestfmt";
    changelog = "https://github.com/GoTestTools/gotestfmt/releases/tag/v${version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ urandom ];
  };
}
