{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "as-tree";
  version = "unstable-2021-03-09";

  src = fetchFromGitHub {
    owner = "jez";
    repo = pname;
    rev = "0036c20f66795774eb9cda3ccbae6ca1e1c19444";
    sha256 = "sha256-80yB89sKIuv7V68p0jEsi2hRdz+5CzE+4R0joRzO7Dk=";
  };

  cargoSha256 = "sha256-BLEVPKO2YwcKuM/rUeMuyE38phOrbq0e8cjqh1qmJjM=";

  meta = with lib; {
    description = "Print a list of paths as a tree of paths";
    homepage = "https://github.com/jez/as-tree";
    license = with licenses; [ blueOak100 ];
    maintainers = with maintainers; [ jshholland ];
    mainProgram = "as-tree";
  };
}
