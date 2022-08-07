{ lib
, fetchFromGitHub
, stdenv
, makeWrapper
, qemu
, gnugrep
, lsb-release
, jq
, procps
, python3
, cdrtools
, usbutils
, util-linux
, spice-gtk
, swtpm
, wget
, xdg-user-dirs
, xrandr
, zsync
, OVMF
, quickemu
, testers
}:
let
  runtimePaths = [
    qemu
    gnugrep
    jq
    lsb-release
    procps
    python3
    cdrtools
    usbutils
    util-linux
    spice-gtk
    swtpm
    wget
    xdg-user-dirs
    xrandr
    zsync
  ];
in

stdenv.mkDerivation rec {
  pname = "quickemu";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "quickemu-project";
    repo = "quickemu";
    rev = version;
    sha256 = "sha256-CiCQg1UsSAwlEnZEmzU2ynn2RZ+wXPv9FV1b9GVkc00=";
  };

  patches = [
    ./input_overrides.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t "$out/bin" quickemu quickget macrecovery

    for f in quickget macrecovery quickemu; do
      wrapProgram $out/bin/$f \
        --prefix PATH : "${lib.makeBinPath runtimePaths}" \
        --set ENV_EFI_CODE "${OVMF.fd}/FV/OVMF_CODE.fd" \
        --set ENV_EFI_VARS "${OVMF.fd}/FV/OVMF_VARS.fd"
    done

    runHook postInstall
  '';

  passthru.tests = testers.testVersion { package = quickemu; };

  meta = with lib; {
    description = "Quickly create and run optimised Windows, macOS and Linux desktop virtual machines";
    homepage = "https://github.com/quickemu-project/quickemu";
    license = licenses.mit;
    maintainers = with maintainers; [ fedx-sudo ];
  };
}
