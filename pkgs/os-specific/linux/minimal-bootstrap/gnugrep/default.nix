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

  # Thanks to the live-bootstrap project!
  # See https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/grep-2.4
  makefile = fetchurl {
    url = "https://github.com/fosslinux/live-bootstrap/raw/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/grep-2.4/mk/main.mk";
    sha256 = "08an9ljlqry3p15w28hahm6swnd3jxizsd2188przvvsj093j91k";
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

    meta = with lib; {
      description = "GNU implementation of the Unix grep command";
      homepage = "https://www.gnu.org/software/grep";
      license = licenses.gpl3Plus;
      maintainers = teams.minimal-bootstrap.members;
      mainProgram = "grep";
      platforms = platforms.unix;
    };
  }
  ''
    # Unpack
    ungz --file ${src} --output grep.tar
    untar --file grep.tar
    rm grep.tar
    cd grep-${version}

    # Configure
    cp ${makefile} Makefile

    # Build
    make CC="tcc -B ${tinycc.libs}/lib"

    # Install
    make install PREFIX=$out
  ''
