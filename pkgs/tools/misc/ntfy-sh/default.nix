{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
  nixosTests,
  debianutils,
  mkdocs,
  python3,
  python3Packages,
}:

buildGoModule rec {
  pname = "ntfy-sh";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    tag = "v${version}";
    hash = "sha256-D4wLIGVItH5lZlfmgd2+QsqB4PHlyX4ORpwT1NGdV60=";
  };

  vendorHash = "sha256-7+nvkyLcdQZ/B4Lly4ygcOGxSLkXXqCqu7xvCB4+8Wo=";

  ui = buildNpmPackage {
    inherit src version;
    pname = "ntfy-sh-ui";
    npmDepsHash = "sha256-oiOv4d+Gxk43gUAZXrTpcsfuEEpGyJMYS19ZRHf9oF8=";

    prePatch = ''
      cd web/
    '';

    installPhase = ''
      mv build/index.html build/app.html
      rm build/config.js
      mkdir -p $out
      mv build/ $out/site
    '';
  };

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [
    debianutils
    mkdocs
    python3
    python3Packages.mkdocs-material
    python3Packages.mkdocs-minify-plugin
  ];

  postPatch = ''
    sed -i 's# /bin/echo# echo#' Makefile
  '';

  preBuild = ''
    cp -r ${ui}/site/ server/
    make docs-build
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.ntfy-sh = nixosTests.ntfy-sh;
  };

  meta = with lib; {
    description = "Send push notifications to your phone or desktop via PUT/POST";
    homepage = "https://ntfy.sh";
    license = licenses.asl20;
    maintainers = with maintainers; [
      arjan-s
      fpletz
    ];
  };
}
