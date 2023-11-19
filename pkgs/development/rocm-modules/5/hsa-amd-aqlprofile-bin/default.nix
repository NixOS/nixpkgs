{ lib
, stdenv
, fetchurl
, callPackage
, dpkg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hsa-amd-aqlprofile-bin";
  version = "5.7.2";

  src = fetchurl {
    url = "https://repo.radeon.com/rocm/apt/5.7.2/pool/main/h/hsa-amd-aqlprofile/hsa-amd-aqlprofile_1.0.0.50702.50702-110~22.04_amd64.deb";
    hash = "sha256-v9LZ9JnGJCNocQM3PhIGPZaXBcQYZ7+85aHvm5geEUI=";
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

  meta = with lib; {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://rocm.docs.amd.com/en/latest/";
    license = with licenses; [ unfree ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
