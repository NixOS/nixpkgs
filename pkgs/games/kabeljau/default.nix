{
  dialog,
  fetchFromGitea,
  just,
  lib,
  makeWrapper,
  python3Packages,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "kabeljau";
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "kabeljau";
    rev = "v${version}";
    hash = "sha256-RedVItgfr6vgqXHA3bOiHXDpfGuHI+sX4jCHL9G5jYk=";
  };

  # `cairosvg` is needed in a `just` recipe where it is used to export the SVG icon to several different sized PNGs.
  nativeBuildInputs = [
    just
    makeWrapper
    python3Packages.cairosvg
  ];

  postPatch = ''
    patchShebangs --host ${pname}
    substituteInPlace ./justfile \
      --replace-quiet " /bin" " $out/bin" \
      --replace-quiet " /usr" " $out" \
      --replace-fail "inkscape" "cairosvg" \
      --replace-quiet "-C -w $icon_width" "-W $icon_width" \
      --replace-quiet "-h $icon_height" "-H $icon_height" \
      --replace-quiet "--export-png-color-mode=RGBA_8" "-f png"
  '';

  installPhase = ''
    runHook preInstall

    just install
    wrapProgram $out/bin/${pname} --suffix PATH : ${lib.makeBinPath [ dialog ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Survive as a stray cat in an ncurses game";
    mainProgram = "kabeljau";
    homepage = "https://codeberg.org/annaaurora/kabeljau";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ annaaurora ];
  };
}
