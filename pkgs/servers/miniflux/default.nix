{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests }:

let
  pname = "miniflux";
  version = "2.0.46";

in buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = "v2";
    rev = version;
    sha256 = "sha256-a27eKOhW2vHmPktLgqHKqiwtC9T6GRwnOeNReeMsaeM=";
  };

  vendorHash = "sha256-Oe7el4tE/gwI6qL/fjJgnv1jbNSKrCnq1nBq+dD7Gik=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "-skip=TestClient" ]; # skip client tests as they require network access

  ldflags = [
    "-s" "-w" "-X miniflux.app/version.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/miniflux.app $out/bin/miniflux
    installManPage miniflux.1
  '';

  passthru.tests = nixosTests.miniflux;

  meta = with lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = "https://miniflux.app/";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs benpye ];
  };
}
