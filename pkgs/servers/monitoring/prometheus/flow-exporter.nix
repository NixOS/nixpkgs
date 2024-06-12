{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "flow-exporter";
  version = "1.1.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "neptune-networks";
    repo = pname;
    sha256 = "sha256-6FqupoYWRvex7XhM7ly8f7ICnuS9JvCRIVEBIJe+64k=";
  };

  vendorHash = "sha256-2raOUOPiMUMydIsfSsnwUAAiM7WyMio1NgL1EoADr2s=";

  meta = with lib; {
    description = "Export network flows from kafka to Prometheus";
    mainProgram = "flow-exporter";
    homepage = "https://github.com/neptune-networks/flow-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ kloenk ];
    platforms = platforms.linux;
  };
}
