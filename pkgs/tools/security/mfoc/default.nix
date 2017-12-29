{ stdenv, fetchurl, pkgconfig, libnfc }:

stdenv.mkDerivation rec {
  name = "mfoc-${version}";
  version = "0.10.6";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mfoc/${name}.tar.gz";
    sha1 = "3adce3029dce9124ff3bc7d0fad86fa0c374a9e3";
  };

  patches = [./mf_mini.patch];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnfc ];

  meta = with stdenv.lib; {
    description = "Mifare Classic Offline Cracker";
    license = licenses.gpl2;
    homepage = https://github.com/nfc-tools/mfoc;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
