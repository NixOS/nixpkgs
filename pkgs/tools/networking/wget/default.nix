{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gettext,
  pkg-config,
  perlPackages,
  libidn2,
  zlib,
  pcre,
  libuuid,
  libiconv,
  libintl,
  python3,
  lzip,
  withLibpsl ? false,
  libpsl,
  withOpenssl ? true,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "wget";
  version = "1.21.4";

  src = fetchurl {
    url = "mirror://gnu/wget/${pname}-${version}.tar.lz";
    hash = "sha256-NoNhml9Q7cvMsXIKeQBvo3v5uaJVqMW0gEi8PHqHS9k=";
  };

  patches = [
    ./remove-runtime-dep-on-openssl-headers.patch
    (fetchpatch {
      name = "CVE-2024-38428.patch";
      url = "https://git.savannah.gnu.org/cgit/wget.git/patch/?id=ed0c7c7e0e8f7298352646b2fd6e06a11e242ace";
      hash = "sha256-4ZVPufgG/h0UkxF9hQBAtF6QAG4GEz9hHeqEsD47q4U=";
    })
  ];

  preConfigure =
    ''
      patchShebangs doc

    ''
    + lib.optionalString doCheck ''
      # Work around lack of DNS resolution in chroots.
      for i in "tests/"*.pm "tests/"*.px
      do
        sed -i "$i" -e's/localhost/127.0.0.1/g'
      done
    '';

  nativeBuildInputs = [
    gettext
    pkg-config
    perlPackages.perl
    lzip
    libiconv
    libintl
  ];
  buildInputs =
    [
      libidn2
      zlib
      pcre
      libuuid
    ]
    ++ lib.optionals doCheck [
      perlPackages.IOSocketSSL
      perlPackages.LWP
      python3
    ]
    ++ lib.optional withOpenssl openssl
    ++ lib.optional withLibpsl libpsl
    ++ lib.optional stdenv.isDarwin perlPackages.perl;

  configureFlags =
    [
      (lib.withFeatureAs withOpenssl "ssl" "openssl")
    ]
    ++ lib.optionals stdenv.isDarwin [
      # https://lists.gnu.org/archive/html/bug-wget/2021-01/msg00076.html
      "--without-included-regex"
    ];

  doCheck = false;

  meta = with lib; {
    description = "Tool for retrieving files using HTTP, HTTPS, and FTP";
    homepage = "https://www.gnu.org/software/wget/";
    license = licenses.gpl3Plus;
    longDescription = ''
      GNU Wget is a free software package for retrieving files using HTTP,
              HTTPS and FTP, the most widely-used Internet protocols.  It is a
              non-interactive commandline tool, so it may easily be called from
              scripts, cron jobs, terminals without X-Windows support, etc.
    '';
    mainProgram = "wget";
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
