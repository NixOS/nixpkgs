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
    edk2
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
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "quickemu-project";
    repo = pname;
    rev = version;
    sha256 = "sha256-15cilf7ccj88c9f4qw1b5mjzgi2f3c854b4xlz1k22xdlx8zwd3f";
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
