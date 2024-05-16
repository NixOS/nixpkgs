{ lib, stdenv, fetchFromGitHub, autoreconfHook, sqlite, pkg-config, dovecot, xapian, icu }:

stdenv.mkDerivation rec {
  pname = "dovecot-fts-xapian";
  version = "1.7.11";

  src = fetchFromGitHub {
    owner = "grosjo";
    repo = "fts-xapian";
    rev = version;
    hash = "sha256-7G+2RezvaBZ/0h7uky20lvGXibCMAF+kOL3h96tythY=";
  };

  buildInputs = [ xapian icu sqlite ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  preConfigure = ''
    export PANDOC=false
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--with-moduledir=$(out)/lib/dovecot"
  ];

  meta = with lib; {
    homepage = "https://github.com/grosjo/fts-xapian";
    description = "Dovecot FTS plugin based on Xapian";
    changelog = "https://github.com/grosjo/fts-xapian/releases";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ julm symphorien ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/dovecot_fts_xapian.x86_64-darwin
  };
}
