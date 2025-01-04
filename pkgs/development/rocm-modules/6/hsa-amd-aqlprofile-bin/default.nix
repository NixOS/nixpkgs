{
  lib,
  stdenv,
  fetchurl,
  callPackage,
  dpkg,
  rocm-core,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hsa-amd-aqlprofile-bin";
  version = "6.3.0";

  src =
    let
      inherit (finalAttrs) version;
      patch = rocm-core.ROCM_LIBPATCH_VERSION;
      majorMinor = lib.versions.major version + "." + lib.versions.minor version;
      incremental = "39";
      osRelease = "22.04";
    in
    fetchurl {
      url = "https://repo.radeon.com/rocm/apt/${majorMinor}/pool/main/h/hsa-amd-aqlprofile/hsa-amd-aqlprofile_1.0.0.${patch}-${incremental}~${osRelease}_amd64.deb";
      hash = "sha256-ghgz5ZgWopgLJcK4Vbwm6zlny3IwxzWz9V0Fuwu35R0=";
    };

  nativeBuildInputs = [ dpkg ];
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a opt/rocm-${finalAttrs.version}*/* $out
    chmod +x $out/lib/libhsa-amd-aqlprofile64.so.1.*
    chmod +x $out/lib/hsa-amd-aqlprofile/librocprofv2_att.so

    runHook postInstall
  '';

  passthru.updateScript = (callPackage ./update.nix { }) { inherit (finalAttrs) version; };

  meta = with lib; {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://rocm.docs.amd.com/en/latest/";
    license = with licenses; [ unfree ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
})
