{ stdenv, fetchgit, python, pyxattr, pylibacl, setuptools, fuse, git, perl, pandoc, makeWrapper
, par2cmdline, par2Support ? false }:

assert par2Support -> par2cmdline != null;

with stdenv.lib;

stdenv.mkDerivation {
  name = "bup-0.25git20121224";

  src = fetchgit {
    url = "https://github.com/bup/bup.git";
    sha256 = "f0e0c835ab83f00b28920d493e4150d2247113aad3a74385865c2a8c6f1ba7b8";
    rev = "458e92da32ddd3c18fc1c3e52a76e9f0b48b832f";
  };

  buildNativeInputs = [ pandoc perl makeWrapper ];

  buildInputs = [ python git ];

  postInstall = optionalString (elem stdenv.system platforms.linux) ''
    wrapProgram $out/bin/bup --prefix PYTHONPATH : \
      ${stdenv.lib.concatStringsSep ":"
          (map (path: "$(toPythonPath ${path})") [ pyxattr pylibacl setuptools fuse ])}
  '';

  patchPhase = ''
    for f in cmd/* lib/tornado/* lib/tornado/test/* t/* wvtest.py main.py; do
      substituteInPlace $f --replace "/usr/bin/env python" "${python}/bin/python"
    done
    substituteInPlace Makefile --replace "./format-subst.pl" "perl ./format-subst.pl"
  '' + optionalString par2Support ''
    substituteInPlace cmd/fsck-cmd.py --replace "['par2'" "['${par2cmdline}/bin/par2'"
  '';

  makeFlags = [
    "MANDIR=$(out)/share/man"
    "DOCDIR=$(out)/share/doc/bup"
    "BINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib/bup"
  ];

  meta = {
    description = ''
      Highly efficient file backup system based on the git packfile format.
      Capable of doing *fast* incremental backups of virtual machine images.
    '';
    homepage = "https://github.com/bup/bup";
  };
}
