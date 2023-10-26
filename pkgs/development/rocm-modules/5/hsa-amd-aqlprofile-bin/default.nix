{ lib
, stdenv
, fetchurl
, dpkg
}:

let
  prefix = "hsa-amd-aqlprofile";
  version = "5.7.0";
  major = lib.versions.major version;
  minor = lib.versions.minor version;
  patch = lib.versions.patch version;
  magic = lib.strings.concatStrings (lib.strings.intersperse "0" (lib.versions.splitVersion version));
in stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "${prefix}-bin";

  src = fetchurl {
    url = "https://repo.radeon.com/rocm/apt/${major}.${minor}/pool/main/h/${prefix}/${prefix}_1.0.0.${magic}.${magic}-63~22.04_amd64.deb";
    hash = "sha256-FQ25eXkhnvOmcf0sGW3GYu9kZj69bVvZrh0jVx/G/kI=";
  };

  nativeBuildInputs = [ dpkg ];
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a opt/rocm-${version}/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://rocm.docs.amd.com/en/latest/";
    license = with licenses; [ unfree ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
