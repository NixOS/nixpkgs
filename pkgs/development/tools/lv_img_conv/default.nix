{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, pkg-config
, python3
, pixman
, libpng
, libjpeg
, librsvg
, giflib
, cairo
, pango
, nodePackages
, makeWrapper
, CoreText
, nix-update-script
}:

buildNpmPackage rec {
  pname = "lv_img_conv";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lvgl";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LB7NZKwrpvps1cKzRoARHL4S48gBHadvxwA6JMmm/ME=";
  };

  npmDepsHash = "sha256-uDF22wlL3BlMQ/+Wmtgyjp4CVN6sDnjqjEPB4SeQuPk=";

  nativeBuildInputs = [
    pkg-config
    python3
    makeWrapper
  ];

  buildInputs = [
    pixman
    libpng
    libjpeg
    librsvg
    giflib
    cairo
    pango
  ] ++ lib.optionals stdenv.isDarwin [
    CoreText
  ];

  postInstall = ''
    makeWrapper ${nodePackages.ts-node}/bin/ts-node $out/bin/lv_img_conv --add-flags $out/lib/node_modules/lv_img_conv/lib/cli.ts
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/lvgl/lv_img_conv/releases/tag/v${version}";
    description = "Image converter for LVGL";
    homepage = "https://github.com/lvgl/lv_img_conv";
    license = licenses.mit;
    maintainers = with maintainers; [ stargate01 ];
  };
}
