{ lib, stdenv, fetchFromGitHub, autoreconfHook, gettext }:

stdenv.mkDerivation {
  pname = "duff";
  # The last release (0.5.2) is more than 2 years old and lacks features like -D,
  # limiting its usefulness. Upstream appears comatose if not dead.
  version = "2014-07-03";

  src = fetchFromGitHub {
    sha256 = "1k2dx38pjzc5d624vw1cs5ipj9fprsm5vqv55agksc29m63lswnx";
    rev = "f26d4837768b062a3f98fa075c791d9c8a0bb75c";
    repo = "duff";
    owner = "elmindreda";
  };

  nativeBuildInputs = [ autoreconfHook gettext ];

  preAutoreconf = ''
    # gettexttize rightly refuses to run non-interactively:
    cp ${gettext}/bin/gettextize .
    substituteInPlace gettextize \
      --replace "read dummy" "echo '(Automatically acknowledged)' #"
    ./gettextize
    sed 's@po/Makefile.in\( .*\)po/Makefile.in@po/Makefile.in \1@' \
      -i configure.ac
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Quickly find duplicate files";
    mainProgram = "duff";
    longDescription = ''
      Duff is a Unix command-line utility for quickly finding duplicates in
      a given set of files.
    '';
    homepage = "https://duff.dreda.org/";
    license = licenses.zlib;
    platforms = platforms.all;
  };
}
