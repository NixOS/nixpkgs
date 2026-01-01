{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
<<<<<<< HEAD
  systemdLibs,
=======
  systemd,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  withSystemdSupport ? true,
}:

buildGoModule rec {
  pname = "postfix_exporter";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Hsn723";
    repo = "postfix_exporter";
    tag = "v${version}";
    sha256 = "sha256-PIZBzDZJkjttxy2pYUAs9G9C/byCNpnhWYuqWJlGgfM=";
  };

  vendorHash = "sha256-FY2bynGrgxBsSlQQ6bnr/NYHt9pmzF/6ST/Ea3cDfF8=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = lib.optionals withSystemdSupport [ makeWrapper ];
<<<<<<< HEAD
  buildInputs = lib.optionals withSystemdSupport [ systemdLibs ];
=======
  buildInputs = lib.optionals withSystemdSupport [ systemd ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  tags = lib.optionals (!withSystemdSupport) "nosystemd";

  postInstall = lib.optionals withSystemdSupport ''
    wrapProgram $out/bin/postfix_exporter \
<<<<<<< HEAD
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemdLibs}/lib"
=======
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) postfix; };

  meta = {
    inherit (src.meta) homepage;
    description = "Prometheus exporter for Postfix";
    mainProgram = "postfix_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      globin
    ];
  };
}
