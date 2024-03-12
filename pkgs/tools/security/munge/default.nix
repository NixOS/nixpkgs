{ lib, stdenv, fetchFromGitHub, autoreconfHook, libgcrypt, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "munge";
  version = "0.5.15";

  src = fetchFromGitHub {
    owner = "dun";
    repo = "munge";
    rev = "${pname}-${version}";
    sha256 = "sha256-Ot/oH/RdfPAzoi3P7EYkxS0Fr24KRWfBJxBEWRF0ctI=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    libgcrypt # provides libgcrypt.m4
  ];
  buildInputs = [ libgcrypt zlib bzip2 ];

  preAutoreconf = ''
    # Remove the install-data stuff, since it tries to write to /var
    substituteInPlace src/Makefile.am --replace "etc \\" "\\"
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
    # workaround for cross compilation: https://github.com/dun/munge/issues/103
    "ac_cv_file__dev_spx=no"
    "x_ac_cv_check_fifo_recvfd=no"
  ];

  meta = with lib; {
    description = ''
      An authentication service for creating and validating credentials
    '';
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.rickynils ];
  };
}
