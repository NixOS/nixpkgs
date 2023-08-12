{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, rpm
, xz
}:

buildGoModule rec {
  pname = "clair";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jnEnzIxI6S5AoUpfurOcf5N2Fo03QFNjxUzkn+i4h0Q=";
  };

  vendorHash = "sha256-6UdTqnbtX4X4qACXW8uybyiOVOGXVw5HBNUvC/l1xfo=";

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
