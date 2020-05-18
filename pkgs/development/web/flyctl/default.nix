{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flyctl";
  version = "0.0.117";

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
    sha256 = "0i9azvhlwp5g699yagfbd5rnsr5kdnbw6lsz28nz1dzvmrj9xp7w";
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