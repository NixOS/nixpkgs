{ lib
, fetchFromGitea
, ocamlPackages
}:

ocamlPackages.buildDunePackage rec {
  pname = "soupault";
  version = "4.0.0";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PataphysicalSociety";
    repo = pname;
    rev = version;
    sha256 = "sha256-txNKAZMd3LReFoAtf6iaoDF+Ku3IUNDzBWUqGC2ePKw=";
  };

  buildInputs = with ocamlPackages; [
    base64
    camomile
    containers
    ezjsonm
    fileutils
    fmt
    jingoo
    lambdasoup
    lua-ml
    logs
    markup
    odate
    otoml
    re
    spelll
    tsort
    yaml
  ];

  meta = {
    description = "A tool that helps you create and manage static websites";
    homepage = "https://soupault.app/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
