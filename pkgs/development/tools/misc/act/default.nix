{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "act";
  version = "0.2.64";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-r/d961IQVZgKh1eT7tFE1KFVwMhp7E8z+jV1AaqBtiQ=";
  };

  vendorHash = "sha256-FveFo78LuTFKEch/5uqdwksS6c7MLbl+xQvZGSVmTko=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kashw2 ];
  };
}
