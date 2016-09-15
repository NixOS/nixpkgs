{ stdenv, fetchFromGitHub, fetchurl, makeWrapper
, perl, pandoc, pythonPackages, git
, par2cmdline ? null, par2Support ? false
}:

assert par2Support -> par2cmdline != null;

let version = "0.28.1"; in

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "bup-${version}";

  src = fetchFromGitHub {
    repo = "bup";
    owner = "bup";
    rev = version;
    sha256 = "1hsxzrjvqa3pd74vmz8agiiwynrzynp1i726h0fzdsakc4adya4l";
  };

  buildInputs = [ git pythonPackages.python ];
  nativeBuildInputs = [ pandoc perl makeWrapper ];

  patches = optional stdenv.isDarwin (fetchurl {
    url = "https://github.com/bup/bup/commit/75d089e7cdb7a7eb4d69c352f56dad5ad3aa1f97.diff";
    sha256 = "05kp47p30a45ip0fg090vijvzc7ijr0alc3y8kjl6bvv3gliails";
    name = "darwin_10_10.patch";
  });

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
        (with pythonPackages; [ pyxattr pylibacl setuptools fuse tornado ]))}
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
