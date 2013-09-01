{ stdenv, fetchgit, python, pyxattr, pylibacl, setuptools, fuse, git, perl, pandoc, makeWrapper
, diffutils, writeTextFile, rsync
, par2cmdline, par2Support ? false }:

# keep in mind you cannot prune older revisions yet! (2013-06)

assert par2Support -> par2cmdline != null;

with stdenv.lib;

stdenv.mkDerivation {
  name = "bup-0.25-rc1-107-g96c6fa2";

  src = fetchgit {
    url = "https://github.com/bup/bup.git";
    rev = "98a8e2ebb775386cb7e66b1953df46cdbd4b4bd3";
    sha256 = "ab01c70f0caf993c0c05ec3a1008b5940b433bf2f7bd4e9b995d85e81958c1b7";
  };

  buildInputs = [ python git ];
  nativeBuildInputs = [ pandoc perl makeWrapper rsync ];

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace Makefile --replace "-Werror" ""
    for f in "cmd/"* "lib/tornado/"* "lib/tornado/test/"* "t/"* wvtest.py main.py; do
      test -f $f || continue
      substituteInPlace $f --replace "/usr/bin/env python" "${python}/bin/python"
    done
    substituteInPlace Makefile --replace "./format-subst.pl" "perl ./format-subst.pl"
    for t in t/*.sh t/configure-sampledata t/compare-trees; do
      substituteInPlace $t --replace "/usr/bin/env bash" "$(type -p bash)"
    done
    substituteInPlace wvtestrun --replace "/usr/bin/env perl" "${perl}/bin/perl"

    substituteInPlace t/test.sh --replace "/bin/pwd" "$(type -P pwd)"
  '' + optionalString par2Support ''
    substituteInPlace cmd/fsck-cmd.py --replace "['par2'" "['${par2cmdline}/bin/par2'"
  '';

  dontAddPrefix = true;

  makeFlags = [
    "MANDIR=$(out)/share/man"
    "DOCDIR=$(out)/share/doc/bup"
    "BINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib/bup"
  ];

  postInstall = optionalString (elem stdenv.system platforms.linux) ''
    wrapProgram $out/bin/bup --prefix PYTHONPATH : \
      ${stdenv.lib.concatStringsSep ":"
          (map (path: "$(toPythonPath ${path})") [ pyxattr pylibacl setuptools fuse python.modules.readline ])}

    ## test it
    make test

    # if make test passes the following probably passes, too
    backup_init(){
      export BUP_DIR=$TMP/bup
      PATH=$out/bin:$PATH
      bup init
    }
    backup_make(){
      ( cd "$1"; tar -cvf - .) | bup split -n backup
    }
    backup_restore_latest(){
      bup join backup | ( cd "$1"; tar -xf - )
    }
    backup_verify_integrity_latest(){
      bup fsck
    }
    backup_verify_latest(){
      # maybe closest would be to mount or use the FTP like server ..
      true
    }

    . ${import ../test-case.nix { inherit diffutils writeTextFile; }}
    backup_test backup 100M
  '';

  meta = {
    homepage = "https://github.com/bup/bup";
    description = "efficient file backup system based on the git packfile format";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      Highly efficient file backup system based on the git packfile format.
      Capable of doing *fast* incremental backups of virtual machine images.
    '';

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
