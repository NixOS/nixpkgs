{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, sqlite
, pkg-config
, dovecot
, libtool
, xapian
, icu64
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dovecot-fts-xapian";
  version = "1.7.10";

  src = fetchFromGitHub {
    owner = "grosjo";
    repo = "fts-xapian";
    rev = "refs/tags/${finalAttrs.version}";
    sha256 = "sha256-Yd14kla33qAx4Hy0ZdE08javvki3t+hCEc3OTO6YfkQ=";
  };

  buildInputs = [ dovecot xapian icu64 sqlite ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  preConfigure = ''
    export PANDOC=false
    autoreconf -vi
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--with-moduledir=$(out)/lib/dovecot"
  ];

  meta = {
    homepage = "https://github.com/grosjo/fts-xapian";
    description = "Dovecot FTS plugin based on Xapian";
    changelog = "https://github.com/grosjo/fts-xapian/releases";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ julm notashelf symphorien ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/dovecot_fts_xapian.x86_64-darwin
  };
})
