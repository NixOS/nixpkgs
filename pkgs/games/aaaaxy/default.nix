{ lib
, fetchFromGitHub
, buildGoModule
, alsa-lib
, libglvnd
, libX11
, libXcursor
, libXext
, libXi
, libXinerama
, libXrandr
, libXxf86vm
, go-licenses
, pkg-config
}:

buildGoModule rec {
  pname = "aaaaxy";
  version = "1.3.372";

  src = fetchFromGitHub {
    owner = "divVerent";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vm3wA8lzoaJ5iGwf2nZ0EvoSATHGftQ77lwdEjGe2RU=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-WEK7j7FMiue0Fl1R+To5GKwvM03pjc1nKig/wePEAAY=";

  buildInputs = [
    alsa-lib
    libglvnd
    libX11 libXcursor libXext libXi libXinerama libXrandr
    libXxf86vm
  ];

  nativeBuildInputs = [
    go-licenses
    pkg-config
  ];

  postPatch = ''
    # Without patching, "go run" fails with the error message:
    # package github.com/google/go-licenses: no Go files in /build/source/vendor/github.com/google/go-licenses
    substituteInPlace scripts/build-licenses.sh --replace \
      '$GO run ''${GO_FLAGS} github.com/google/go-licenses' 'go-licenses'
  '';

  makeFlags = [
    "BUILDTYPE=release"
  ];

  buildPhase = ''
    runHook preBuild
    AAAAXY_BUILD_USE_VERSION_FILE=true make $makeFlags
    runHook postBuild
  '';

  postInstall = ''
    install -Dm755 'aaaaxy' -t "$out/bin/"
    install -Dm444 'aaaaxy.svg' -t "$out/share/icons/hicolor/scalable/apps/"
    install -Dm644 'aaaaxy.png' -t "$out/share/icons/hicolor/128x128/apps/"
    install -Dm644 'aaaaxy.desktop' -t "$out/share/applications/"
    install -Dm644 'io.github.divverent.aaaaxy.metainfo.xml' -t "$out/share/metainfo/"
  '';

  checkPhase = ''
    runHook preCheck

    # Can't get GLX to work even though it seems to work in their CI system:
    # [FATAL] RunGame exited abnormally: APIUnavailable: GLX: GLX extension not found
    # xvfb-run sh scripts/regression-test-demo.sh aaaaxy \
    #   "on track for Any%, All Paths and No Teleports" \
    #   ./aaaaxy assets/demos/benchmark.dem

    runHook postCheck
  '';

  strictDeps = true;

  meta = with lib; {
    description = "A nonlinear 2D puzzle platformer taking place in impossible spaces";
    homepage = "https://divverent.github.io/aaaaxy/";
    license = licenses.asl20;
    maintainers = with maintainers; [ Luflosi ];
    platforms = platforms.linux;
  };
}
