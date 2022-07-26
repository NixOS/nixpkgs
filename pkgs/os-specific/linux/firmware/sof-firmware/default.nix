{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "sof-firmware";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof-bin";
    rev = "v${version}";
    sha256 = "sha256-/OYYfIJWMT+rBBhSCtHaSWvwRMlReEQ5y4FuMfk5zUg=";
  };

  dontFixup = true; # binaries must not be stripped or patchelfed

  installPhase = ''
    runHook preInstall
    cd "v${lib.versions.majorMinor version}.x"
    mkdir -p $out/lib/firmware/intel/
    cp -a sof-v${version} $out/lib/firmware/intel/sof
    cp -a sof-tplg-v${version} $out/lib/firmware/intel/sof-tplg
    runHook postInstall
  '';

  meta = with lib; {
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with licenses; [ bsd3 isc ];
    maintainers = with maintainers; [ lblasc evenbrenden hmenke ];
    platforms = with platforms; linux;
  };
}
