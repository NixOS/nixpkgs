{
  stdenv,
  lib,
  fetchsvn,
  linux,
  scripts ? fetchsvn {
    url = "https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/branches/";
    rev = "19872";
    hash = "sha256-zbs5iWCaDtwovJLHnBlHfDBZ2DbggToRj3YZ5Nbx/RM=";
  },
  ...
}@args:

let
  majorMinor = lib.versions.majorMinor linux.modDirVersion;

  major = lib.versions.major linux.modDirVersion;
  minor = lib.versions.minor linux.modDirVersion;
  patch = lib.versions.patch linux.modDirVersion;

  # See http://linux-libre.fsfla.org/pub/linux-libre/releases
  versionPrefix = if linux.kernelOlder "5.14" then "gnu1" else "gnu";
in
linux.override {
  argsOverride = {
    modDirVersion = "${linux.modDirVersion}-${versionPrefix}";
    isLibre = true;
    pname = "linux-libre";

    src = stdenv.mkDerivation {
      name = "${linux.name}-libre-src";
      src = linux.src;

      buildPhase = ''
        runHook preBuild

        # --force flag to skip empty files after deblobbing
        ${scripts}/${majorMinor}/deblob-${majorMinor} --force ${major} ${minor} ${patch}

        runHook postBuild
      '';

      checkPhase = ''
        runHook preCheck

        ${scripts}/deblob-check

        runHook postCheck
      '';

      installPhase = ''
        runHook preInstall

        cp -r . "$out"

        runHook postInstall
      '';
    };

    extraPassthru.updateScript = ./update-libre.sh;

    maintainers = with lib.maintainers; [ qyliss ];
  };
}
// (args.argsOverride or { })
