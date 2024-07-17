{
  stdenvNoCC,
  lib,
  fetchFromGitea,
  just,
  inkscape,
  makeWrapper,
  bash,
  dialog,
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

  # Inkscape is needed in a just recipe where it is used to export the SVG icon to several different sized PNGs.
  nativeBuildInputs = [
    just
    inkscape
    makeWrapper
  ];
  postPatch = ''
    patchShebangs --host ${pname}
    substituteInPlace ./justfile \
      --replace " /bin" " $out/bin" \
      --replace " /usr" " $out"
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
