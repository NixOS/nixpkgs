{ lib
, fetchFromGitHub
, stdenv
, makeWrapper
, edk2
, qemu
, gnugrep
, lsb-release
, jq
, procps
, python3
, cdrtools
, usbutils
, util-linux
, spicy
, swtpm
, wget
, xdg-user-dirs
, xrandr
, zsync
}:
let
  runtimePaths = [
    qemu
    edk2
    gnugrep
    jq
    lsb-release
    procps
    python3
    cdrtools
    usbutils
    util-linux
    spicy
    swtpm
    wget
    xdg-user-dirs
    xrandr
    zsync
  ];
in

stdenv.mkDerivation rec {
  pname = "quickemu";
  version = "3.11";

  src = fetchFromGitHub {
    owner = "quickemu-project";
    repo = pname;
    rev = version;
    sha256 = "sha256-1oCgUZ2YB4Ib+8Bhpw90bnRXrQz0Y+a6r/yUvPhOjvc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t "$out/bin" quickemu quickget macrecovery

   for f in quickget macrecovery quickemu; do
    wrapProgram $out/bin/$f --prefix PATH : "${lib.makeBinPath runtimePaths}"
   done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Quickly create and run optimised Windows, macOS and Linux desktop virtual machines";
    homepage = "https://github.com/quickemu-project/quickemu";
    license = licenses.mit;
    maintainers = with maintainers; [ fedx-sudo ];
  };
}
