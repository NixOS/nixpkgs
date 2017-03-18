{ stdenv, fetchFromGitHub, fetchurl, makeWrapper
, perl, pandoc, python2Packages, git
, par2cmdline ? null, par2Support ? false
}:

assert par2Support -> par2cmdline != null;

let version = "0.29"; in

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "bup-${version}";

  src = fetchFromGitHub {
    repo = "bup";
    owner = "bup";
    rev = version;
    sha256 = "1cc9kpq9bpln89m4ni6wqzh4c8zwxmgnhaibdxxfs5pk2mpl3ds5";
  };

  buildInputs = [ git python2Packages.python ];
  nativeBuildInputs = [ pandoc perl makeWrapper ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace "-Werror" ""
    substituteInPlace Makefile --replace "./format-subst.pl" "${perl}/bin/perl ./format-subst.pl"
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

  postInstall = ''
    wrapProgram $out/bin/bup \
      --prefix PATH : ${git}/bin \
      --prefix PYTHONPATH : ${concatStringsSep ":" (map (x: "$(toPythonPath ${x})")
        (with python2Packages;
         [ setuptools tornado ]
         ++ stdenv.lib.optionals (!stdenv.isDarwin) [ pyxattr pylibacl fuse ]))}
  '';

  meta = {
    homepage = "https://github.com/bup/bup";
    description = "Efficient file backup system based on the git packfile format";
    license = licenses.gpl2Plus;

    longDescription = ''
      Highly efficient file backup system based on the git packfile format.
      Capable of doing *fast* incremental backups of virtual machine images.
    '';

    platforms = platforms.linux;
    maintainers = with maintainers; [ muflax ];
  };
}
