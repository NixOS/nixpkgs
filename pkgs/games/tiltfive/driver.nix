{ stdenv
, lib
, autoPatchelfHook
, fetchurl
, nixosTests

, glfw
, udev
}:

let srcs = import ./srcs.nix { inherit fetchurl; }; in
stdenv.mkDerivation {
  pname = "tiltfive-driver";
  version = srcs.version;

  srcs = srcs.driver;

  buildInputs = [
    glfw
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  runtimeDependencies = [
    udev
  ];

  installPhase = ''
    runHook preInstall

    cd tiltfive-service_${srcs.version}_amd64/files/

    mkdir -p $out/bin
    install -Dm755 opt/tiltfive/bin/* -t $out/bin/

    mkdir -p $out/var/opt/tiltfive/firmware/
    install -Dm644 var/opt/tiltfive/firmware/* -t $out/var/opt/tiltfive/firmware/

    cp opt/tiltfive/LICENSE* $out/

    runHook postInstall
  '';

  passthru.tests.tiltfive = nixosTests.tiltfive;

  meta = with lib; {
    description = "Tilt Five™ Glasses driver / userspace service";
    homepage = "https://docs.tiltfive.com/index.html";
    # Non-redistributable. See: LICENSE.service.txt, 2.1.2.
    license = with licenses; unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ q3k ];
    platforms = [ "x86_64-linux" ];
  };
}
