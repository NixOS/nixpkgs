{ lib
, buildNpmPackage
, fetchFromGitHub
, python3
, nix-update-script
}:

buildNpmPackage rec {
  pname = "lv_font_conv";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "lvgl";
    repo = pname;
    rev = version;
    hash = "sha256-7eTsmFSi4yvDz5zmBUD9r1sxKTDr+z5Vs3XKfzjyDYs=";
  };

  npmDepsHash = "sha256-D1gKMaODfqRtwPoXgUOz71LRVEKiFRaMblsdRVI7wo0=";

  nativeBuildInputs = [
    python3
  ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Converts fonts to the LVGL font format";
    homepage = "https://github.com/lvgl/lv_font_conv";
    changelog = "https://github.com/lvgl/lv_font_conv/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ raphaelr ];
  };
}
