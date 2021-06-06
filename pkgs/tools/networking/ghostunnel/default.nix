{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGoModule rec {
  pname = "ghostunnel";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "ghostunnel";
    repo = "ghostunnel";
    rev = "v${version}";
    sha256 = "15rmd89j7sfpznzznss899smizbyshprsrvsdmrbhb617myd9fpy";
  };

  vendorSha256 = "1i95fx4a0fh6id6iy6afbva4pazr7ym6sbwi9r7la6gxzyncd023";

  meta = with lib; {
    description = "A simple TLS proxy with mutual authentication support for securing non-TLS backend applications";
    homepage = "https://github.com/ghostunnel/ghostunnel#readme";
    license = licenses.asl20;
    maintainers = with maintainers; [ roberth ];
  };

  passthru.tests.nixos = nixosTests.ghostunnel;
}
