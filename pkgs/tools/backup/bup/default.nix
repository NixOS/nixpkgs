{ stdenv, fetchzip, python, pyxattr, pylibacl, setuptools, fuse, git, perl, pandoc, makeWrapper
, par2cmdline, par2Support ? false }:

assert par2Support -> par2cmdline != null;

let version = "0.26"; in

with stdenv.lib;

stdenv.mkDerivation {
  name = "bup-${version}";

  src = fetchzip {
    url = "https://github.com/bup/bup/archive/${version}.tar.gz";
    sha256 = "0g7b0xl3kg0z6rn81fvzl1xnvva305i7pjih2hm68mcj0adk3v0d";
  };

  buildInputs = [ python git ];
  nativeBuildInputs = [ pandoc perl makeWrapper ];

  patchPhase = ''
    patchShebangs .
    substituteInPlace Makefile --replace "-Werror" ""
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
    maintainers = with stdenv.lib.maintainers; [ muflax ];

  };
}
