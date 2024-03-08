{ lib, buildGoModule, fetchFromGitHub, buildNpmPackage
, nixosTests, debianutils, mkdocs, python3, python3Packages
}:


buildGoModule rec {
  pname = "ntfy-sh";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    hash = "sha256-nCW7D2iQEv9NeIvVn1+REacspchzJ7SJgl0glEWkAoE=";
  };

  vendorHash = "sha256-nnAw3BIiPMNa/7WSH8vurt8GUFM7Bf80CmtH4WjfC6Q=";

  ui = buildNpmPackage {
    inherit src version;
    pname = "ntfy-sh-ui";
    npmDepsHash = "sha256-+4VL+bY3Nz5LT5ZyW9aJlrl3NsfOGv6CaiwLqpC5ywo=";

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

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [
    debianutils
    mkdocs
    python3
    python3Packages.mkdocs-material
    python3Packages.mkdocs-minify-plugin
    python3Packages.mkdocs-simple-hooks
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
    maintainers = with maintainers; [ arjan-s fpletz ];
  };
}
