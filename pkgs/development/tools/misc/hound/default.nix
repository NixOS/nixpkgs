{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, mercurial
, git
, openssh
, nixosTests
}:

buildGoModule rec {
  pname = "hound";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "hound-search";
    repo = "hound";
    rev = "v${version}";
    sha256 = "sha256-Qdk57zLjTXLdDEmB6K+sZAym5s0BekJJa/CpYeOBOcY=";
  };

  vendorHash = "sha256-0psvz4bnhGuwwSAXvQp0ju0GebxoUyY2Rjp/D43KF78=";

  nativeBuildInputs = [ makeWrapper ];

  # requires network access
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/houndd --prefix PATH : ${lib.makeBinPath [ mercurial git openssh ]}
  '';

  passthru.tests = { inherit (nixosTests) hound; };

  meta = with lib; {
    description = "Lightning fast code searching made easy";
    homepage = "https://github.com/hound-search/hound";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc SuperSandro2000 ];
  };
}
