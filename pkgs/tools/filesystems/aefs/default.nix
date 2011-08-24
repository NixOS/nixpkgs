{ stdenv, fetchurl, fuse, fetchsvn }:
  
stdenv.mkDerivation rec {
  name = "aefs-0.3pre288";
  
  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.tar.bz2";
    sha256 = "0s102s75h7ycjppvbankadsgpw6w1p4fc676zdpd64x8s66bs6lp";
  };

  buildInputs = [ fuse ];

  meta = {
    homepage = http://www.st.ewi.tudelft.nl/~dolstra/aefs/;
    description = "A cryptographic filesystem implemented in userspace using FUSE";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
