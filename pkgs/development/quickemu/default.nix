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
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "wimpysworld";
    repo = pname;
    rev = version;
    sha256 = "sha256-TNG1pCePsi12QQafhayhj+V5EXq+v7qmaW5v5X8ER6s=";
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
    homepage = "https://github.com/wimpysworld/quickemu";
    license = licenses.mit;
    maintainers = with maintainers; [ fedx-sudo ];
  };
}
