{ stdenv, fetchFromGitHub, makeWrapper
, perl, pandoc, python2Packages, git
, par2cmdline ? null, par2Support ? true
}:

assert par2Support -> par2cmdline != null;

let version = "0.29.2"; in

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "bup";
  inherit version;

  src = fetchFromGitHub {
    repo = "bup";
    owner = "bup";
    rev = version;
    sha256 = "17lpbyhf43gcln5s43m2zzgichcx7jq6ragcawfklw6svg1vnj89";
  };

  buildInputs = [
    git
    (python2Packages.python.withPackages
      (p: with p; [ setuptools tornado ]
        ++ stdenv.lib.optionals (!stdenv.isDarwin) [ pyxattr pylibacl fuse ]))
  ];
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
      --prefix PATH : ${git}/bin
  '';

  meta = {
    homepage = https://github.com/bup/bup;
    description = "Efficient file backup system based on the git packfile format";
    license = licenses.gpl2Plus;

    longDescription = ''
      Highly efficient file backup system based on the git packfile format.
      Capable of doing *fast* incremental backups of virtual machine images.
    '';

    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ muflax ];
  };
}
