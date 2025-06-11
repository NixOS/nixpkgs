{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  systemd,
  withSystemdSupport ? true,
}:

buildGoModule rec {
  pname = "postfix_exporter";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Hsn723";
    repo = "postfix_exporter";
    tag = "v${version}";
    sha256 = "sha256-z+qQ/5g6RBSDqtDx8H7BZmg12g2TR0+B2WV6XZBGg0w=";
  };

  vendorHash = "sha256-eZAB6GlZkSrW/sU5pAUlY4MKm/16bv3cBj+z4ZN4Ugw=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = lib.optionals withSystemdSupport [ makeWrapper ];
  buildInputs = lib.optionals withSystemdSupport [ systemd ];
  tags = lib.optionals (!withSystemdSupport) "nosystemd";

  postInstall = lib.optionals withSystemdSupport ''
    wrapProgram $out/bin/postfix_exporter \
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postfix; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for Postfix";
    mainProgram = "postfix_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      globin
    ];
  };
}
