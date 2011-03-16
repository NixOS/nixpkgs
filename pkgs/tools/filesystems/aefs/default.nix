{ stdenv, fetchurl, fuse }:
  
stdenv.mkDerivation rec {
  name = "aefs-0.3pre287";
  
  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.tar.bz2";
    sha256 = "07ndb1cs05l83birrn55cy1ks54q5gbvmhzb3r5cflmd8n4byhyl";
  };

  buildInputs = [ fuse ];

  meta = {
    homepage = http://www.st.ewi.tudelft.nl/~dolstra/aefs/;
    description = "A cryptographic filesystem implemented in userspace using FUSE";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
