{stdenv, fetchurl, openssl}:

stdenv.mkDerivation {
  name = "mktorrent-1.0.0";

  src = fetchurl {
    url = mirror://sourceforge/mktorrent/mktorrent-1.0.tar.gz;
    sha256 = "17qi3nfky240pq6qcmf5qg324mxm83vk9r3nvsdhsvinyqm5d3kg";
  };

  makeFlags = "USE_PTHREADS=1 USE_OPENSSL=1 USE_LONG_OPTIONS=1" +
    stdenv.lib.optionalString stdenv.isi686 " USE_LARGE_FILES=1";

  preInstall = ''
    installFlags=PREFIX=$out
  '';

  buildInputs = [ openssl ];

  meta = {
    homepage = http://mktorrent.sourceforge.net/;
    license = "GPLv2+";
    description = "Command line utility to create BitTorrent metainfo files";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
