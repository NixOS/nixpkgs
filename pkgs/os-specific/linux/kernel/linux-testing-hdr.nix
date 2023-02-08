{ lib, fetchFromGitLab, buildLinux, ... } @ args:

# NOTE: This patched kernel is based upon amd-staging-drm-next
buildLinux (args // rec {
  version = "6.0-unstable-2023-01-17";
  extraMeta.branch = lib.versions.majorMinor version;

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = "6.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "JoshuaAshton";
    repo = "linux-hdr";
    rev = "ff57328e57842bb2e0475449fc598ff84e88d55c";
    hash = "sha256-RS2AMybUw2tqxY3wDs1bWrNsaGeEsiXYLKEoqmgPMu0=";
  };

  # Never build it on Hydra
  extraMeta.hydraPlatforms = [];

  # Some unavailable options
  structuredExtraConfig = with lib.kernel; {
    ANDROID = lib.mkOverride 60 (option no);
    DRM_AMD_DC_DCN = lib.mkOverride 60 (option no);
    DRM_AMD_DC_HDCP = lib.mkOverride 60 (option no);
    LRU_GEN = lib.mkOverride 60 (option no);
    LRU_GEN_ENABLED = lib.mkOverride 60 (option no);
  };

} // (args.argsOverride or {}))
