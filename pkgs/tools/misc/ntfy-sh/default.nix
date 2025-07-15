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
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    tag = "v${version}";
    hash = "sha256-fnnDVx84dc0iHA1Xa7AgdiBzLxCm4UIZjbMkc24GLVI=";
  };

  vendorHash = "sha256-DXvQbVKFviGhTosW4F+FB/tbJBzM5FHULWv4cO3RnK4=";

  ui = buildNpmPackage {
    inherit src version;
    pname = "ntfy-sh-ui";
    npmDepsHash = "sha256-SmSItsOjpi874c2AK/3Xmtb0/PisXM+07eoQEEYWKt0=";

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
