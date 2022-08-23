{ lib, stdenv, fetchFromGitHub, makeBinaryWrapper, bash, age, git ? null
, xclip ? null }:

stdenv.mkDerivation {
  pname = "passage";
  version = "unstable-2022-05-01";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "passage";
    rev = "1262d308f09db9b243513a428ab4b8fb1c30d31d";
    sha256 = "1val8wl9kzlxj4i1rrh2iiyf97w9akffvr0idvbkdb09hfzz4lz8";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  extraPath = lib.makeBinPath [ age git xclip ];

  # Using $0 is bad, it causes --help to mention ".passage-wrapped".
  postInstall = ''
    substituteInPlace $out/bin/passage --replace 'PROGRAM="''${0##*/}"' 'PROGRAM=passage'
    wrapProgram $out/bin/passage --prefix PATH : $extraPath --argv0 $pname
  '';

  installFlags = [ "PREFIX=$(out)" "WITH_ALLCOMP=yes" ];

  meta = with lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage    = "https://github.com/FiloSottile/passage";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ kaction ];
    platforms   = platforms.unix;

    longDescription = ''
      passage is a fork of password-store (https://www.passwordstore.org) that uses
      age (https://age-encryption.org) as a backend instead of GnuPG.

      It keeps passwords inside age(1) encrypted files inside a simple
      directory tree and provides a series of commands for manipulating the
      password store, allowing the user to add, remove, edit and synchronize
      passwords.
    '';
  };
}
