{ stdenv, lib, fetchsvn, linux
, scripts ? fetchsvn {
    url = "https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/branches/";
    rev = "18713";
    sha256 = "10744jp1i7z3jwpc42vrmdfpq1yblf3vy17yb04xdfhimkflw77p";
  }
, ...
}:

let
  majorMinor = lib.versions.majorMinor linux.modDirVersion;

  major = lib.versions.major linux.modDirVersion;
  minor = lib.versions.minor linux.modDirVersion;
  patch = lib.versions.patch linux.modDirVersion;

  # See http://linux-libre.fsfla.org/pub/linux-libre/releases
  versionPrefix = if linux.kernelOlder "5.14" then
    "gnu1"
  else
    "gnu";
in linux.override {
  argsOverride = {
    modDirVersion = "${linux.modDirVersion}-${versionPrefix}";
    isLibre = true;

    src = stdenv.mkDerivation {
      name = "${linux.name}-libre-src";
      src = linux.src;
      buildPhase = ''
        # --force flag to skip empty files after deblobbing
        ${scripts}/${majorMinor}/deblob-${majorMinor} --force \
            ${major} ${minor} ${patch}
      '';
      checkPhase = ''
        ${scripts}/deblob-check
      '';
      installPhase = ''
        cp -r . "$out"
      '';
    };

    passthru.updateScript = ./update-libre.sh;

    maintainers = with lib.maintainers; [ qyliss ivar ];
  };
}
