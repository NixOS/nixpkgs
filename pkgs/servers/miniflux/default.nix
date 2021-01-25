{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests }:

let
  pname = "miniflux";
  version = "2.0.23";

in buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0v0n5lvrfn3ngs1s1m3hv95dvnqn8ysksb044m4ifk2cr3b77ryc";
  };

  vendorSha256 = "1iin5r9l8wb9gm0bwgdmpx0cp1q35ij4y7zf98lnj2kvb3jv5crp";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = true;

  buildFlagsArray = ''
    -ldflags=-s -w -X miniflux.app/version.Version=${version}
  '';

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
