{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-core";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm-core";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-jFAHLqf/AR27Nbuq8aypWiKqApNcTgG5LWESVjVCKIg=";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DROCM_VERSION=${finalAttrs.version}" ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Utility for getting the ROCm release version";
    homepage = "https://github.com/RadeonOpenCompute/rocm-core";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
