{
  lib,
  fetchFromGitLab,
  mkTclDerivation,
  xclip,
  curl,
  gnutar,
  coreutils,
}:

mkTclDerivation rec {
  pname = "jimlib";
  version = "0.16.0";

  src = fetchFromGitLab {
    owner = "dbohdan";
    repo = "jimlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-a7Su/JByGLgnYBCRbP9z9CunTIYTwAisWuQafZWYgYo=";
  };

  dontBuild = true;

  postPatch = ''
    substituteInPlace jimlib.tcl \
      --replace-fail "exec curl" "exec ${lib.getExe curl}" \
      --replace-fail "exec tar"  "exec ${lib.getExe gnutar}" \
      --replace-fail "exec uname" "exec ${lib.getExe' coreutils "uname"}" \
      --replace-fail "exec xclip" "exec ${lib.getExe xclip}"
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 jimlib.tcl pkgIndex.tcl -t $out/lib/jimlib
    runHook postInstall
  '';

  meta = {
    homepage = "https://gitlab.com/dbohdan/jimlib/";
    description = "Personal standard library for Jim Tcl";
    license = with lib.licenses; [
      mit
      tcltk
      bsd3
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ neosloth ];
  };
}
