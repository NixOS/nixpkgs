{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, cups
, libcupsfilters
, ghostscript
, pkg-config
, poppler_utils
, mupdf
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libppd";
  version = "2.0b2";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libppd";
    rev = version;
    hash = "sha256-4KRJfzK/xeWlXmhUOlvGHsMmKqF6R4e5BiIA+h2UTII=";
  };

  configureFlags = [
    "--with-mutool-path=${lib.getBin mupdf}/bin/mutool"
    "--with-pdftops=pdftops"
    "--with-pdftops-path=${lib.getBin poppler_utils}/bin/pdftops"
    "--with-gs-path=${lib.getBin ghostscript}/bin/gs"
    "--with-pdftocairo-path=${lib.getBin poppler_utils}/bin/pdftocairo"
    "--with-ippfind-path=${lib.getBin cups}/bin/ippfind"
    "--disable-acroread"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [
    cups
    ghostscript
    poppler_utils
    mupdf
    libcupsfilters
    zlib
  ];

  # Fix missing includes on darwin
  patches = lib.optionals (stdenv.hostPlatform.libc != "glibc") [
    ./libppd-libc-compat.patch
    ./libppd-zlib.patch
  ];

  postInstall = ''
    rmdir $out/bin
  '';

  meta =
    let homepage = "https://github.com/OpenPrinting/libppd";
    in with lib; {
      description = "Legacy support library for PPD files";
      inherit homepage;
      changelog = "${homepage}/releases/tag/${version}";
      license = licenses.asl20;
      maintainers = with maintainers; [ tmarkus ];
      platforms = platforms.unix;
    };
}

