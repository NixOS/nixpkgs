{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.123";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "1gs796n2cw8kpfsqr21zqxzp8dmnhhmjfy7vnpi838566i5ql9q3";
  };

  preBuild = ''
    go generate ./...
  '';

  preFixup = ''
    rm $out/bin/doc
    rm $out/bin/helpgen
  '';

  vendorSha256 = "10wcyxzkwvbhf86dq1rh852zgdg28draay0515zp459z34vv4zna";

  meta = with lib; {
    description = "Command line tools for fly.io services";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse ];
  };
}