{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libgcrypt,
  zlib,
  bzip2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "munge";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "dun";
    repo = "munge";
    rev = "munge-${finalAttrs.version}";
    sha256 = "sha256-fv42RMUAP8Os33/iHXr70i5Pt2JWZK71DN5vFI3q7Ak=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libgcrypt # provides libgcrypt.m4
  ];

  buildInputs = [
    libgcrypt
    zlib
    bzip2
  ];

  strictDeps = true;

  configureFlags = [
    "--localstatedir=/var"

    # Cross-compilation hacks
    "--with-libgcrypt-prefix=${lib.getDev libgcrypt}"
    # workaround for cross compilation: https://github.com/dun/munge/issues/103
    "ac_cv_file__dev_spx=no"
    "x_ac_cv_check_fifo_recvfd=no"
  ];

  preAutoreconf = ''
    # Remove the install-data stuff, since it tries to write to /var
    substituteInPlace src/Makefile.am --replace "etc \\" "\\"
  '';

  meta = with lib; {
    description = ''
      An authentication service for creating and validating credentials
    '';
    license = [
      # MUNGE
      licenses.gpl3Plus
      # libmunge
      licenses.lgpl3Plus
    ];
    platforms = platforms.unix;
    maintainers = [ maintainers.rickynils ];
  };
})
