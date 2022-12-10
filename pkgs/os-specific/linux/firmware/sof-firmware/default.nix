{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "sof-firmware";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof-bin";
    rev = "v${version}";
    sha256 = "sha256-ztewE/8Mc0bbKbxmbJ2sBn3TysuM9hoaSgqrboy77oI=";
  };

  dontFixup = true; # binaries must not be stripped or patchelfed

  # There is no proper structure in the upstream repo.
  # This needs to be adapted by hand for every new release.
  installPhase = ''
    runHook preInstall
    cd "v2.2.x"
    mkdir -p $out/lib/firmware/intel/sof{,-tplg}
    cp -a sof-v2.2/* $out/lib/firmware/intel/sof
    cp -a sof-v2.2.2/* $out/lib/firmware/intel/sof
    cp -a sof-tplg-v2.2.1/* $out/lib/firmware/intel/sof-tplg
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
