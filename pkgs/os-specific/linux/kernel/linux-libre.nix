{ stdenv, lib, fetchsvn, linux
, scripts ? fetchsvn {
    url = "https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/branches/";
    rev = "17506";
    sha256 = "0yial2fib8bvv31ihzlxn80xlnpx8f0z6ml9md5xj3zxzslsy5iq";
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

    maintainers = [ lib.maintainers.qyliss ];
  };
}
