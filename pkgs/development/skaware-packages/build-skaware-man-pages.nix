{
  lib,
  stdenv,
  fetchFromSourcehut,
  nix-update-script,
}:

{
  # : string
  pname,
  # : string
  version,
  # : string
  sha256,
  # : string
  description,
  # : list Maintainer
  maintainers,
  # : license
  license ? lib.licenses.isc,
  # : string
  owner ? "~flexibeast",
  # : string
  rev ? "v${version}",
}:

let
  manDir = "${placeholder "out"}/share/man";

  src = fetchFromSourcehut {
    inherit owner rev sha256;
    repo = pname;
  };
in

stdenv.mkDerivation {
  inherit pname version src;

  makeFlags = [
    "MAN_DIR=${manDir}"
  ];

  dontBuild = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--override-filename"
      "pkgs/development/skaware-packages/${lib.removeSuffix "-man-pages" pname}/default.nix"
    ];
  };

  meta = with lib; {
    inherit description license maintainers;
    inherit (src.meta) homepage;
    platforms = platforms.all;
  };
}
