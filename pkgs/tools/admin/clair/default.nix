{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, rpm
, xz
}:

buildGoModule rec {
  pname = "clair";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+ABZafDc2nmHHnJGXj4iCSheuWoksPwDblmdIusUJuo=";
  };

  vendorHash = "sha256-ptgHU/PrLqRG4h3C5x+XUy4+38Yu6h4gTeziaPJ2iWE=";

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
