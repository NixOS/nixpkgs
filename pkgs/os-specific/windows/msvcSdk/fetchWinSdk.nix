{
  lib,
  config,
  stdenvNoCC,
  xwin,
}:
let
  host = stdenvNoCC.hostPlatform;

  hostArch =
    if host.isx86_64 then
      "x86_64"
    else if host.isAarch64 then
      "aarch64"
    else if host.isx86_32 then
      "x86"
    else if host.isAarch32 then
      "aarch"
    else
      throw "Unsupported system";
in
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "manifest"
    "arch"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      name ? "xwin-fetch-msvc",
      hash ? lib.fakeHash,
      manifest ? null,
      arch ? hostArch,
      ...
    }@args:
    {
      inherit name;
      __structuredAttrs = true;
      dontUnpack = true;
      dontFixup = true;
      dontInstall = true;

      strictDeps = true;

      nativeBuildInputs = [ xwin ];

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash =
        if !config.microsoftVisualStudioLicenseAccepted then
          throw ''
            Microsoft Software License Terms are not accepted with config.microsoftVisualStudioLicenseAccepted.
            Please read https://visualstudio.microsoft.com/license-terms/mt644918/ and if you agree, change your
            config to indicate so.
          ''
        else
          hash;

      xwinArgs = lib.optionals (manifest != null) [ "--manifest=${manifest}" ] ++ [
        "--accept-license"
        "--cache-dir=${placeholder "out"}"
        "--arch=${arch}"
        "download"
      ];

      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          xwin "''${xwinArgs[@]}"

          runHook postBuild
        '';

      passthru = {
        inherit arch;
      };

      meta.license = {
        deprecated = false;
        fullName = "Microsoft Software License Terms";
        shortName = "msvc";
        spdxId = "unknown";
        free = false;
        url = "https://www.visualstudio.com/license-terms/mt644918/";
      };
    };
}
