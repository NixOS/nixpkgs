{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, rpm
, xz
}:

buildGoModule rec {
  pname = "clair";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Dl1wwK4OSv/nvhT7bH6qOdX4/qL3xFdmz5qiYaEm59Y=";
  };

  vendorHash = "sha256-NqEpJHBZfzUQJ+H8CQBDdb37nlwA+JuXhZzfCAyO0Co=";

  nativeBuildInputs = [
    makeWrapper
  ];

  subPackages = [
    "cmd/clair"
    "cmd/clairctl"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/clair \
      --prefix PATH : "${lib.makeBinPath [ rpm xz ]}"
  '';

  meta = with lib; {
    description = "Vulnerability Static Analysis for Containers";
    homepage = "https://github.com/quay/clair";
    changelog = "https://github.com/quay/clair/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
