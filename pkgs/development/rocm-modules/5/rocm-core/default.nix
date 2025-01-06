{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-core";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "ROCm";
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
    page = "tags?per_page=1";
    filter = ".[0].name | split(\"-\") | .[1]";
  };

  meta = {
    description = "Utility for getting the ROCm release version";
    homepage = "https://github.com/ROCm/rocm-core";
    license = with lib.licenses; [ mit ];
    maintainers = lib.teams.rocm.members;
    platforms = lib.platforms.linux;
    broken =
      lib.versions.minor finalAttrs.version != lib.versions.minor stdenv.cc.version
      || lib.versionAtLeast finalAttrs.version "6.0.0";
  };
})
