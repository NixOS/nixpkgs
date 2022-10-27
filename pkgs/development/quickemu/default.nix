{ lib
, fetchFromGitHub
, stdenv
, makeWrapper
, qemu
, gnugrep
, gnused
, lsb-release
, jq
, procps
, python3
, cdrtools
, usbutils
, util-linux
, socat
, spice-gtk
, swtpm
, unzip
, wget
, xdg-user-dirs
, xrandr
, zsync
, OVMF
, OVMFFull
, quickemu
, testers
}:
let
  runtimePaths = [
    qemu
    gnugrep
    gnused
    jq
    lsb-release
    procps
    python3
    cdrtools
    usbutils
    util-linux
    unzip
    socat
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
  version = "4.4";

  src = fetchFromGitHub {
    owner = "quickemu-project";
    repo = "quickemu";
    rev = version;
    hash = "sha256-82ojq1WTcgkVh+DQup2ymmqa6d6+LVR2p5cqEHA3hSM=";
  };

  postPatch = ''
    sed -i \
      -e '/OVMF_CODE_4M.secboot.fd/s|ovmfs=(|ovmfs=("${OVMFFull.fd}/FV/OVMF_CODE.fd","${OVMFFull.fd}/FV/OVMF_VARS.fd" |' \
      -e '/OVMF_CODE_4M.fd/s|ovmfs=(|ovmfs=("${OVMF.fd}/FV/OVMF_CODE.fd","${OVMF.fd}/FV/OVMF_VARS.fd" |' \
      -e '/cp "''${VARS_IN}" "''${VARS_OUT}"/a chmod +w "''${VARS_OUT}"' \
      -e 's/Icon=.*qemu.svg/Icon=qemu/' \
      quickemu
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t "$out/bin" macrecovery quickemu quickget windowskey

    for f in macrecovery quickget quickemu windowskey; do
      wrapProgram $out/bin/$f --prefix PATH : "${lib.makeBinPath runtimePaths}"
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
