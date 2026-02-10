{
  lib,
  fetchurl,
  bash,
  tinycc,
  gnumake,
}:
let
  pname = "gnugrep";
  version = "2.4";

  src = fetchurl {
    url = "mirror://gnu/grep/grep-${version}.tar.gz";
    sha256 = "05iayw5sfclc476vpviz67hdy03na0pz2kb5csa50232nfx34853";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      tinycc.compiler
      gnumake
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/grep --version
        mkdir ''${out}
      '';

    meta = {
      description = "GNU implementation of the Unix grep command";
      homepage = "https://www.gnu.org/software/grep";
      license = lib.licenses.gpl3Plus;
      teams = [ lib.teams.minimal-bootstrap ];
      mainProgram = "grep";
      platforms = lib.platforms.unix;
    };
  }
  ''
    # Unpack
    ungz --file ${src} --output grep.tar
    untar --file grep.tar
    rm grep.tar
    cd grep-${version}

    # Configure
    cp ${./main.mk} Makefile

    # Build
    make CC="tcc -B ${tinycc.libs}/lib"

    # Install
    make install PREFIX=$out
  ''
