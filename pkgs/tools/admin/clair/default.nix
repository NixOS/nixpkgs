{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, rpm
, xz
}:

buildGoModule rec {
  pname = "clair";
  version = "4.7.3";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LRjlchhEXLTZDH3v2lkY3XN4tvXOHpedZBjkQ6rgeVc=";
  };

  vendorHash = "sha256-cAeEBJz4k2liivRsNF4FT4JPKsDVy2fLAYDg8NuJ81U=";

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
    maintainers = with maintainers; [ ];
  };
}
