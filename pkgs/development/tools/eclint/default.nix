{ lib
, buildGoModule
, fetchFromGitLab
}:

buildGoModule
rec {
  pname = "eclint";
  version = "0.3.6";

  src = fetchFromGitLab {
    owner = "greut";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+ZbBmdCl1v4msFFA2kzL/IQTQtR39O5XYgCj7w+QGzE=";
  };

  vendorSha256 = "sha256-CdvxY3uX6i3Xtg50jqlNr+VXpeOeg8M27huasbzA96M=";

  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://gitlab.com/greut/eclint";
    description = "EditorConfig linter written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
