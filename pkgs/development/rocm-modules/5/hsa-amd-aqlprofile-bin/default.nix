{
  lib,
  stdenv,
  fetchurl,
  callPackage,
  dpkg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hsa-amd-aqlprofile-bin";
  version = "5.7.1";

  src = fetchurl {
    url = "https://repo.radeon.com/rocm/apt/5.7.1/pool/main/h/hsa-amd-aqlprofile/hsa-amd-aqlprofile_1.0.0.50701.50701-98~22.04_amd64.deb";
    hash = "sha256-LWAtZ0paJW8lhE+QAMwq2l8wM+96bxk5rNWyQXTc9Vo=";
  };

  nativeBuildInputs = [ dpkg ];
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a opt/rocm-${finalAttrs.version}/* $out
    chmod +x $out/lib/libhsa-amd-aqlprofile64.so.1.*
    chmod +x $out/lib/hsa-amd-aqlprofile/librocprofv2_att.so

    runHook postInstall
  '';

  passthru.updateScript = (callPackage ./update.nix { }) { inherit (finalAttrs) version; };

  meta = {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://rocm.docs.amd.com/en/latest/";
    license = with lib.licenses; [ unfree ];
    maintainers = lib.teams.rocm.members;
    platforms = lib.platforms.linux;
    broken =
      lib.versions.minor finalAttrs.version != lib.versions.minor stdenv.cc.version
      || lib.versionAtLeast finalAttrs.version "6.0.0";
  };
})
