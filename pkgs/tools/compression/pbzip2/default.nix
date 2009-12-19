{stdenv, fetchurl, bzip2}:

let name = "pbzip2";
    version = "1.0.5";
in
stdenv.mkDerivation {
  name = name + "-" + version;

  src = fetchurl {
    url = "http://compression.ca/${name}/${name}-${version}.tar.gz";
    sha256 = "0vc9r6b2djhpwslavi2ykv6lk8pwf4lqb107lmapw2q8d658qpa1";
  };

  buildInputs = [ bzip2 ];
  installPhase = ''
      make install PREFIX=$out
  '';

  meta = {
    homepage = http://compression.ca/pbzip2/;
    description = "A parallel implementation of bzip2 for multi-core machines";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
