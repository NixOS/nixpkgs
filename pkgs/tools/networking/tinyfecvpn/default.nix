{ lib, stdenv, fetchFromGitHub, pkg-config }:

stdenv.mkDerivation rec {
  pname = "tinyfecvpn";
  version = "20210116.0";

  src = fetchFromGitHub {
    owner = "wangyu-";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ng5AZJfrnNXSSbhJKBc+giNp2yOWta0EozWHB7lFUmw=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config ];

  patchPhase = ''
    runHook prePatch
    find . -type f -name "makefile" -exec sed "s/ -static/ -g/g" -i \{\} \;
    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 tinyvpn $out/bin/tinyvpn
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wangyu-/tinyfecVPN";
    description = "A VPN Designed for Lossy Links, with Build-in Forward Error Correction(FEC) Support";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
