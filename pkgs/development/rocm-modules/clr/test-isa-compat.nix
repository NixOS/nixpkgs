{
  lib,
  stdenv,
  makeImpureTest,
  fetchFromGitHub,
  clr,
  rocm-smi,
  name,
  offloadArches,
}:

let
  # TODO: swap to another tiny test if this breaks; upstream is archived but fine for now
  vectoradd = stdenv.mkDerivation {
    pname = "rocm-hip-vectoradd";
    version = "2024-04-11";

    src = fetchFromGitHub {
      owner = "ROCm";
      repo = "HIP-Examples";
      rev = "cdf9d101acd9a3fc89ee750f73c1f1958cbd5cc3";
      hash = "sha256-/I1KmOBFbEZIjA1vRE+2tPTtEKtOgazjCbnZtr+87E0=";
    };

    nativeBuildInputs = [
      clr
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      amdclang++ -x hip -o $out/bin/vectoradd \
        ${lib.concatMapStringsSep " " (arch: "--offload-arch=${arch}") offloadArches} \
        vectorAdd/vectoradd_hip.cpp

      runHook postInstall
    '';

    meta = {
      description = "vectorAdd HIP example for ROCm";
      homepage = "https://github.com/ROCm/HIP-Examples";
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      teams = [ lib.teams.rocm ];
    };
  };

in
makeImpureTest {
  inherit name;
  testedPackage = "rocmPackages.clr";

  sandboxPaths = [
    "/sys"
    "/dev/dri"
    "/dev/kfd"
  ];

  nativeBuildInputs = [
    vectoradd
    rocm-smi
  ];

  testScript = ''
    rocm-smi

    vectoradd
  '';

  meta = {
    teams = [ lib.teams.rocm ];
  };
}
