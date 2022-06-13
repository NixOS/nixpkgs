{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, rpm
, xz
}:

buildGoModule rec {
  pname = "clair";
  version = "4.4.4";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QfNFms1OxKPk6vimagMFGWJSl9L7JEM1rIK5kNpZlfg=";
  };

  vendorSha256 = "sha256-Y3eymnLVbDmisV3RDAYkV+I6kTe/CoG0yLvZBOrTfig=";

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
