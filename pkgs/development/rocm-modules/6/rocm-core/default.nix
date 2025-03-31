{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-core";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-core";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-sgL1UMt3o01zA8v41dyCG1fAsK/PkTRsHQJOvlNatZ4=";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DROCM_VERSION=${finalAttrs.version}" ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
    page = "tags?per_page=1";
    filter = ".[0].name | split(\"-\") | .[1]";
  };

  meta = with lib; {
    description = "Utility for getting the ROCm release version";
    homepage = "https://github.com/ROCm/rocm-core";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
