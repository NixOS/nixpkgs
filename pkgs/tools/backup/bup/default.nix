{ stdenv, fetchgit, python, pyxattr, pylibacl, setuptools, fuse, git, perl, pandoc, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "bup-0.25git20120722";

  src = fetchgit {
    url = "https://github.com/apenwarr/bup.git";
    sha256 = "3ad232d7f23071ed34f920bd4c3137583f1adffbe23c022896289bc0a03fe7aa";
    rev = "02bd2b566ea5eec2fd656e0ae572b4c7b6b9550a";
  };

  nativeBuildInputs = [ pandoc perl makeWrapper ];

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
    substituteInPlace lib/bup/csetup.py \
      --replace "'bupsplit.c'])" "'bupsplit.c'], library_dirs=['${python}/lib'])"
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
    homepage = "https://github.com/apenwarr/bup";
  };
}
