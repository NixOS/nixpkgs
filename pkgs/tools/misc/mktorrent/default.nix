{stdenv, fetchFromGitHub, openssl}:

stdenv.mkDerivation rec {
  name = "mktorrent-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "Rudde";
    repo = "mktorrent";
    rev = "v${version}";
    sha256 = "17pdc5mandl739f8q26n5is8ga56s83aqcrwhlnnplbxwx2inidr";
  };

  makeFlags = "USE_PTHREADS=1 USE_OPENSSL=1 USE_LONG_OPTIONS=1"
    + stdenv.lib.optionalString stdenv.isi686 " USE_LARGE_FILES=1"
    + stdenv.lib.optionalString stdenv.isLinux "CFLAGS=-lgcc_s";

  preInstall = ''
    installFlags=PREFIX=$out
  '';

  buildInputs = [ openssl ];

  meta = {
    homepage = http://mktorrent.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Command line utility to create BitTorrent metainfo files";
    maintainers = with stdenv.lib.maintainers; [viric profpatsch];
  };
}
