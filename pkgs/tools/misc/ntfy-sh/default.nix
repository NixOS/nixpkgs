{ lib, buildGoModule, fetchFromGitHub, buildNpmPackage
, nixosTests, debianutils, mkdocs, python3, python3Packages
}:


buildGoModule rec {
  pname = "ntfy-sh";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "binwiederhier";
    repo = "ntfy";
    rev = "v${version}";
    hash = "sha256-YO6nf1tY+tEgPlvq7JDgeG0ywE8+HEpZH7ToFzvYfvY=";
  };

  vendorHash = "sha256-Gvk/EI5b6AIYBCKYqSFKva0SfiWI/oNCeq7cTyVRpwY=";

  ui = buildNpmPackage {
    inherit src version;
    pname = "ntfy-sh-ui";
    npmDepsHash = "sha256-G2yEIiKc/gxcUPS+97B68C/HukabGZAX2XY1gstGBvg=";

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
