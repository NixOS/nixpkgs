{ stdenv, fetchFromGitHub, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "tinyfecvpn";
  version = "20180820.0";

  src = fetchFromGitHub {
    owner = "wangyu-";
    repo = pname;
    rev = version;
    sha256 = "1mbb9kzvy24na375dz0rlf5k93gan1vahamc9wzkn34mcx8i97cs";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];

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

  meta = with stdenv.lib; {
    homepage = "https://github.com/wangyu-/tinyfecVPN";
    description = "A VPN Designed for Lossy Links, with Build-in Forward Error Correction(FEC) Support";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
