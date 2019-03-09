{ stdenv, lib, fetchsvn, linux
, scripts ? fetchsvn {
    url = "https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/tags/";

    # Update this if linux_latest-libre fails to build.
    # $ curl https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/tags/ | grep -Eo 'Revision [0-9]+'
    rev = "15951";
    sha256 = "196k8zr5xsfnvbrgh9cvr70yfdl9bngxrc4bh0bq3a4w6nnh1cda";
  }
, ...
}:

let
  majorMinor = lib.versions.majorMinor linux.modDirVersion;

  major = lib.versions.major linux.modDirVersion;
  minor = lib.versions.minor linux.modDirVersion;
  patch = lib.versions.patch linux.modDirVersion;

in linux.override {
  argsOverride = {
    modDirVersion = "${linux.modDirVersion}-gnu";

    src = stdenv.mkDerivation {
      name = "${linux.name}-libre-src";
      src = linux.src;
      buildPhase = ''
        ${scripts}/${majorMinor}-gnu/deblob-${majorMinor} \
            ${major} ${minor} ${patch}
      '';
      checkPhase = ''
        ${scripts}/deblob-check
      '';
      installPhase = ''
        cp -r . "$out"
      '';
    };

    maintainers = [ lib.maintainers.qyliss ];
  };
}
