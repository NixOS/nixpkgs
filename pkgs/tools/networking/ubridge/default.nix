{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  testers,
  ubridge,
}:

stdenv.mkDerivation rec {
  pname = "ubridge";
  version = "0.9.18";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "ubridge";
    rev = "v${version}";
    sha256 = "0jg66jhhpv4c9340fsdp64hf9h253i8r81fknxa0gq241ripp3jn";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "/usr/local/bin" "$out/bin" \
      --replace "setcap" "#setcap"
  '';

  buildInputs = [ libpcap ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 ubridge $out/bin/ubridge

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = ubridge;
      command = "ubridge -v";
    };
  };

  meta = with lib; {
    description = "Bridge for UDP tunnels, Ethernet, TAP, and VMnet interfaces";
    longDescription = ''
      uBridge is a simple application to create user-land bridges between
      various technologies. Currently bridging between UDP tunnels, Ethernet
      and TAP interfaces is supported. Packet capture is also supported.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/GNS3/ubridge/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    mainProgram = "ubridge";
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
