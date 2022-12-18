{
  lib,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  libreswan,
  nixosTests,
}:
buildGoModule rec {
  pname = "ipsec-exporter";
  version = "0.4.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "dennisstritzke";
    repo = "ipsec_exporter";
    sha256 = "sha256-t094iWEVhjxHj55yVDafsz/C8kYgLrWz8QQxRzHXEKU=";
  };

  vendorSha256 = "sha256-Bwmz/LLCWdtcl5PfvyMjlT68vBvgWvKeGIsMNw6tMhw=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ipsec_exporter --prefix PATH : ${lib.makeBinPath [ libreswan ]}
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) ipsec; };

  meta = with lib; {
    description = "Prometheus exporter for IPsec metrics.";
    homepage = "https://github.com/dennisstritzke/ipsec_exporter";
    changelog = "https://github.com/dennisstritzke/ipsec_exporter/blob/master/CHANGELOG.md";
    license = licenses.mit;
  };
}
