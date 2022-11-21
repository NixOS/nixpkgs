{ lib
, fetchFromGitHub
, fetchpatch
, buildGoModule
}:

buildGoModule rec {
  pname = "smartctl_exporter";
  version = "unstable-2020-11-14";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "e27581d56ad80340fb076d3ce22cef337ed76679";
    sha256 = "sha256-iWaFDjVLBIAA9zGe0utbuvmEdA3R5lge0iCh3j2JfE8=";
  };

  patches = [
    # Fixes out of range panic (https://github.com/prometheus-community/smartctl_exporter/issues/19)
    (fetchpatch {
      url = "https://github.com/prometheus-community/smartctl_exporter/commit/15575301a8e2fe5802a8c066c6fa9765d50b8cfa.patch";
      sha256 = "sha256-HLUrGXNz3uKpuQBUgQBSw6EGbGl23hQnimTGl64M5bQ=";
    })
    # Fix validation on empty smartctl response (https://github.com/prometheus-community/smartctl_exporter/pull/31)
    (fetchpatch {
      url = "https://github.com/prometheus-community/smartctl_exporter/commit/744b4e5f6a46e029d31d5aa46642e85f429c2cfa.patch";
      sha256 = "sha256-MgLtYR1SpM6XrZQQ3AgQRmNF3OnaBCqXMJRV9BOzKPc=";
    })
    # Fixes missing metrics if outside of query interval (https://github.com/prometheus-community/smartctl_exporter/pull/18)
    ./0001-Return-the-cached-value-if-it-s-not-time-to-scan-aga.patch
  ];

  vendorSha256 = "1xhrzkfm2p20k7prgdfax4408g4qpa4wbxigmcmfz7kjg2zi88ld";

  meta = with lib; {
    description = "Export smartctl statistics for Prometheus";
    homepage = "https://github.com/prometheus-community/smartctl_exporter";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexa ];
  };
}
