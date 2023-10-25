{ lib, buildGoModule, fetchFromGitHub, buildNpmPackage
, nixosTests, debianutils, mkdocs, python3, python3Packages
}:


buildGoModule rec {
  pname = "ntfy-sh";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    hash = "sha256-VX5QXJqHvYE8n/TcSBIg8vuLx2OCe6rM87G1PXBiKRI=";
  };

  vendorHash = "sha256-KcA35MVtF/bHtdiMqofs9gSnjl6oYedgqpKZtnFce20=";

  ui = buildNpmPackage {
    inherit src version;
    pname = "ntfy-sh-ui";
    npmDepsHash = "sha256-JvoTssXiBnl/H4odFqRoGtQz2pGwQL4BGxX8Vp/PBwY=";

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
    python3Packages.mkdocs-minify
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
