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
, zip
, advancecomp
, nixosTests
}:

buildGoModule rec {
  pname = "aaaaxy";
  version = "1.4.18";

  src = fetchFromGitHub {
    owner = "divVerent";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g2xUBh0zRB+9awYEr15ay0k+EyAiWmGG5UfZatE24/8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-9SeNXOl1wEcG/CtNuuYQ8Y5XEw2GYAIQ2lXk5lgXsN8=";

  buildInputs = [
    alsa-lib
    libglvnd
    libX11 libXcursor libXext libXi libXinerama libXrandr
    libXxf86vm
  ];

  nativeBuildInputs = [
    go-licenses
    pkg-config
    zip
    advancecomp
  ];

  outputs = [ "out" "testing_infra" ];

  postPatch = ''
    # Without patching, "go run" fails with the error message:
    # package github.com/google/go-licenses: no Go files in /build/source/vendor/github.com/google/go-licenses
    substituteInPlace scripts/build-licenses.sh --replace \
      '$GO run ''${GO_FLAGS} github.com/google/go-licenses' 'go-licenses'

    patchShebangs scripts/
    substituteInPlace scripts/regression-test-demo.sh \
      --replace 'sh scripts/run-timedemo.sh' "$testing_infra/scripts/run-timedemo.sh"
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

    install -Dm755 'scripts/run-timedemo.sh' -t "$testing_infra/scripts/"
    install -Dm755 'scripts/regression-test-demo.sh' -t "$testing_infra/scripts/"
    install -Dm644 'assets/demos/benchmark.dem' -t "$testing_infra/assets/demos/"
  '';

  passthru.tests = {
    aaaaxy = nixosTests.aaaaxy;
  };

  strictDeps = true;

  meta = with lib; {
    description = "A nonlinear 2D puzzle platformer taking place in impossible spaces";
    homepage = "https://divverent.github.io/aaaaxy/";
    license = licenses.asl20;
    maintainers = with maintainers; [ Luflosi ];
    platforms = platforms.linux;
  };
}
