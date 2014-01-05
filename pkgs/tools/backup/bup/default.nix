{ stdenv, fetchgit, python, pyxattr, pylibacl, setuptools, fuse, git, perl, pandoc, makeWrapper
, par2cmdline, par2Support ? false }:

assert par2Support -> par2cmdline != null;

let rev = "96c6fa2a70425fff1e73d2e0945f8e242411ab58"; in

with stdenv.lib;

stdenv.mkDerivation {
  name = "bup-0.25-rc1-107-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    url = "https://github.com/bup/bup.git";
    inherit rev;
    sha256 = "0d9hgyh1g5qcpdvnqv3a5zy67x79yx9qx557rxrnxyzqckp9v75n";
  };

  buildInputs = [ python git ];
  nativeBuildInputs = [ pandoc perl makeWrapper ];

  patchPhase = ''
    substituteInPlace Makefile --replace "-Werror" ""
    for f in "cmd/"* "lib/tornado/"* "lib/tornado/test/"* "t/"* wvtest.py main.py; do
      test -f $f || continue
      substituteInPlace $f --replace "/usr/bin/env python" "${python}/bin/python"
    done
    substituteInPlace Makefile --replace "./format-subst.pl" "perl ./format-subst.pl"
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
          (map (path: "$(toPythonPath ${path})") [ pyxattr pylibacl setuptools fuse ])}
  '';

  meta = {
    homepage = "https://github.com/bup/bup";
    description = "efficient file backup system based on the git packfile format";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      Highly efficient file backup system based on the git packfile format.
      Capable of doing *fast* incremental backups of virtual machine images.
    '';

    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
