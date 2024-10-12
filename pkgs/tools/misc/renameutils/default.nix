{lib, stdenv, fetchurl, readline, coreutils }:

stdenv.mkDerivation rec {
  pname = "renameutils";
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://savannah/renameutils/renameutils-${version}.tar.gz";
    sha256 = "18xlkr56jdyajjihcmfqlyyanzyiqqlzbhrm6695mkvw081g1lnb";
  };

  patches = [ ./install-exec.patch ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/apply.c \
      --replace "command = \"mv\"" "command = \"${coreutils}/bin/mv\"" \
      --replace "command = \"cp\"" "command = \"${coreutils}/bin/cp\""
    substituteInPlace src/icmd.c \
      --replace "#define MV_COMMAND \"mv\"" "#define MV_COMMAND \"${coreutils}/bin/mv\"" \
      --replace "#define CP_COMMAND \"cp\"" "#define CP_COMMAND \"${coreutils}/bin/cp\""
    substituteInPlace src/qcmd.c \
      --replace "ls_program = xstrdup(\"ls\")" "ls_program = xstrdup(\"${coreutils}/bin/ls\")"
  '';

  nativeBuildInputs = [ readline ];

  preConfigure = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    export ac_cv_func_lstat64=no
  '';

  meta = {
    homepage = "https://www.nongnu.org/renameutils/";
    description = "Set of programs to make renaming of files faster";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
