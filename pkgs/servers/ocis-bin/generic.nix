{
  autoPatchelfHook,
  fetchurl,
  hashes,
  lib,
  maintainers ? [ lib.maintainers.ramblurr ],
  nixosTests,
  pname,
  stdenv,
  updateScript,
  version,
}:

let
  systemToArch = {
    i686-linux = "386";
    x86_64-linux = "amd64";
    aarch64-linux = "arm64";
    armv7l-linux = "arm";
    aarch64-darwin = "arm64";
  };

  arch =
    systemToArch.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  os =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "darwin"
    else
      throw "Unsupported OS";

  hash = hashes."hash_${arch}-${os}";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/owncloud/ocis/releases/download/v${finalAttrs.version}/ocis-${finalAttrs.version}-${os}-${arch}";
    inherit hash;
  };

  dontUnpack = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -D $src $out/bin/ocis
    runHook postInstall
  '';

  passthru = {
    tests.ocis = nixosTests.ocis.${finalAttrs.pname};
    inherit updateScript;
  };

  meta = {
    description = "ownCloud Infinite Scale Stack";
    homepage = "https://owncloud.dev/ocis/";
    changelog = "https://github.com/owncloud/ocis/releases/tag/v${finalAttrs.version}";
    # oCIS is licensed under a non-free EULA:
    # https://github.com/owncloud/ocis/releases/download/v5.0.1/End-User-License-Agreement-for-ownCloud-Infinite-Scale.pdf
    license = lib.licenses.unfree;
    inherit maintainers;
    platforms = builtins.attrNames systemToArch;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "ocis";
  };
})
