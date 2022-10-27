{ lib
, stdenv
, fetchFromGitHub
, pciutils
, pkg-config
, python3
}:

stdenv.mkDerivation rec {
  pname = "x86info";
  version = "unstable-2021-08-07";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = pname;
    rev = "061ea35ecb0697761b6260998fa2045b8bb0be68";
    hash = "sha256-/qWioC4dV1bQkU4SiTR8duYqoGIMIH7s8vuAXi75juo=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    pciutils
  ];

  postBuild = ''
    patchShebangs lsmsr/createheader.py
    make -C lsmsr
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp x86info $out/bin
    cp lsmsr/lsmsr $out/bin
  '';

  meta = {
    description = "Identification utility for the x86 series of processors";
    longDescription = ''
      x86info will identify all Intel/AMD/Centaur/Cyrix/VIA CPUs. It leverages
      the cpuid kernel module where possible.  it supports parsing model specific
      registers (MSRs) via the msr kernel module.  it will approximate processor
      frequency, and identify the cache sizes and layout.
    '';
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = lib.licenses.gpl2;
    homepage = "https://github.com/kernelslacker/x86info";
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
