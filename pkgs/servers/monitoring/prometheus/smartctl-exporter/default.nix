{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
, smartmontools
}:

buildGoModule rec {
  pname = "smartctl_exporter";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QQoWAsnE/7ifvgEfQJ6cbzmwOrE7oe2zalTbu/P7r18=";
  };

  vendorHash = "sha256-WUB2FgBl4Tybz7T0yvcSYIlG75NEhXpn1F0yuB9F21g=";

  postPatch = ''
    substituteInPlace main.go README.md \
      --replace-fail /usr/sbin/smartctl ${lib.getExe smartmontools}
  '';

  ldflags = [
    "-X github.com/prometheus/common/version.Version=${version}"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smartctl; };

  meta = with lib; {
    description = "Export smartctl statistics for Prometheus";
    mainProgram = "smartctl_exporter";
    homepage = "https://github.com/prometheus-community/smartctl_exporter";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexa Frostman ];
  };
}
