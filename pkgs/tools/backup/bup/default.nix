{ lib, stdenv, fetchFromGitHub, makeWrapper
, perl, pandoc, python3, git
, par2cmdline ? null, par2Support ? true
}:

assert par2Support -> par2cmdline != null;

let
  version = "0.33.2";

  pythonDeps = with python3.pkgs; [ setuptools tornado ]
    ++ lib.optionals (!stdenv.isDarwin) [ pyxattr pylibacl fuse ];
in

stdenv.mkDerivation {
  pname = "bup";
  inherit version;

  src = fetchFromGitHub {
    repo = "bup";
    owner = "bup";
    rev = version;
    hash = "sha256-DDVCrY4SFqzKukXm8rIq90xAW2U+yYyhyPmUhslMMWI=";
  };

  buildInputs = [ git python3 ];
  nativeBuildInputs = [ pandoc perl makeWrapper ];

  postPatch = "patchShebangs .";

  dontAddPrefix = true;

  makeFlags = [
    "MANDIR=$(out)/share/man"
    "DOCDIR=$(out)/share/doc/bup"
    "BINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib/bup"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-error=implicit-function-declaration";

  postInstall = ''
    wrapProgram $out/bin/bup \
      --prefix PATH : ${lib.makeBinPath [ git par2cmdline ]} \
      --prefix NIX_PYTHONPATH : ${lib.makeSearchPathOutput "lib" python3.sitePackages pythonDeps}
  '';

  meta = with lib; {
    homepage = "https://github.com/bup/bup";
    description = "Efficient file backup system based on the git packfile format";
    license = licenses.gpl2Plus;

    longDescription = ''
      Highly efficient file backup system based on the git packfile format.
      Capable of doing *fast* incremental backups of virtual machine images.
    '';

    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
