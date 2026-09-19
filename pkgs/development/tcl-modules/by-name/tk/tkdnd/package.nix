{
  lib,
  mkTclDerivation,
  fetchFromGitHub,

  cmake,
  xvfb,

  tk,
  libx11,
  libxcursor,
}:
mkTclDerivation (finalAttrs: {
  pname = "tkdnd";
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "petasis";
    repo = "tkdnd";
    tag = "tkdnd-release-test-v${finalAttrs.version}";
    hash = "sha256-VF1f9HSEThyFy3u7d3Kvo7EIpoosz6KpLOiHkf89PQI=";
  };

  nativeBuildInputs = [
    cmake
    xvfb
  ];

  buildInputs = [
    tk
    libx11
    libxcursor
  ];

  postInstall = ''
    mkdir -p $out/lib
    mv $out/tkdnd${finalAttrs.version} $out/lib
  '';

  # Requires X server for tclRequiresCheck
  postFixup = ''
    export DISPLAY=:$((2000 + $RANDOM % 1000))
    Xvfb $DISPLAY -screen 5 1024x768x8 &
    xvfb_pid=$!
  '';

  tclRequiresCheck = [ "tkdnd" ];

  postDist = ''
    kill $xvfb_pid
  '';

  meta = {
    description = "Extension to the Tk toolkit that adds native drag and drop support";
    homepage = "https://github.com/petasis/tkdnd";
    changelog = "https://github.com/petasis/tkdnd/raw/refs/tags/${finalAttrs.src.tag}/Changelog";
    license = lib.licenses.tcltk;
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
