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
  version = "6.3.3";

  src =
    let
      inherit (finalAttrs) version;
      patch = rocm-core.ROCM_LIBPATCH_VERSION;
      majorMinor = lib.versions.majorMinor version;
      poolVersion = if majorMinor + ".0" == version then majorMinor else version;
      incremental = "74";
      osRelease = "22.04";
    in
    fetchurl {
      url = "https://repo.radeon.com/rocm/apt/${poolVersion}/pool/main/h/hsa-amd-aqlprofile/hsa-amd-aqlprofile_1.0.0.${patch}-${incremental}~${osRelease}_amd64.deb";
      hash = "sha256-Lo6gU9ywkujtsKvnOAwL3L8qQNPwjjm0Pm4OyzoUYao=";
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
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
