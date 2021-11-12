{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "sof-firmware";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof-bin";
    rev = "v${version}";
    sha256 = "sha256-yife3gO8lXOGwRye213II9rCQqDic7B7w1xW1o7ajF8=";
  };

  dontFixup = true; # binaries must not be stripped or patchelfed

  installPhase = ''
    runHook preInstall
    cd "v${version}.x"
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
