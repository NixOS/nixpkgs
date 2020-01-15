{ stdenv, lib, fetchsvn, linux
, scripts ? fetchsvn {
    url = "https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/tags/";

    # Update this if linux_latest-libre fails to build.
    # $ curl https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/tags/ | grep -Eo 'Revision [0-9]+'
    rev = "16604";
    sha256 = "0d2dh52zv073zr74ilspy0fy3ivys5pq32j7fljs4fwi2bcljf51";
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
