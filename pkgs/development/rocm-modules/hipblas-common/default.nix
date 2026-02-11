{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  rocm-cmake,
  rocmUpdateScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hipblas-common";
  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "hipBLAS-common";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-sswqYIv3c5ArT6dQ3MRru7ZZVA0VxoKW/a0pYTBpjgE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    rocm-cmake
  ];

  strictDeps = true;

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };
  meta = {
    description = "Common files shared by hipBLAS and hipBLASLt";
    homepage = "https://github.com/ROCm/hipBLASlt";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
