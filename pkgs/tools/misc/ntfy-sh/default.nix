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
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    hash = "sha256-lSj4LfS4nBC1xtTE/ee2Nhx9TmlU+138miwC0nEfVRY=";
  };

  vendorHash = "sha256-V8LgbprUsr+8Ub4xeTPrE4Bp9qOP/R35/qPj0Udgod0=";

  ui = buildNpmPackage {
    inherit src version;
    pname = "ntfy-sh-ui";
    npmDepsHash = "sha256-PCkRULHfC3ktShO+3wIQFLG24l5LBSB1niWcIrCT9Bo=";

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
