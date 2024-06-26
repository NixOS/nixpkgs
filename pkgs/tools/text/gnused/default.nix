{
  lib,
  stdenv,
  fetchurl,
  updateAutotoolsGnuConfigScriptsHook,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "gnused";
  version = "4.9";

  src = fetchurl {
    url = "mirror://gnu/sed/sed-${version}.tar.xz";
    sha256 = "sha256-biJrcy4c1zlGStaGK9Ghq6QteYKSLaelNRljHSSXUYE=";
  };

  outputs = [
    "out"
    "info"
  ];

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    perl
  ];
  preConfigure = "patchShebangs ./build-aux/help2man";

  # Prevents attempts of running 'help2man' on cross-built binaries.
  PERL = if stdenv.hostPlatform == stdenv.buildPlatform then null else "missing";

  meta = {
    homepage = "https://www.gnu.org/software/sed/";
    description = "GNU sed, a batch stream editor";

    longDescription = ''
      Sed (stream editor) isn't really a true text editor or text
      processor.  Instead, it is used to filter text, i.e., it takes
      text input and performs some operation (or set of operations) on
      it and outputs the modified text.  Sed is typically used for
      extracting part of a file using pattern matching or substituting
      multiple occurrences of a string within a file.
    '';

    license = lib.licenses.gpl3Plus;

    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mic92 ];
    mainProgram = "sed";
  };
}
