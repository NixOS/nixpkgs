{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "modemmanager-exporter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "modemmanager_exporter";
    rev = "v${version}";
    sha256 = "0d8z7qzk5j5jj0ixkwpi8dw9kki78mxrajdlzzcj2rcgbnwair91";
  };

  vendorSha256 = "0f6v97cvzdz7wygswpm87wf8r169x5rw28908vqhmqk644hli4zy";

  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) modemmanager; };

  meta = with lib; {
    homepage = "https://github.com/mdlayher/modemmanager_exporter";
    description = "Prometheus exporter for ModemManager and its devices";
    license = licenses.mit;
    maintainers = with maintainers; [ mdlayher ];
  };
}
