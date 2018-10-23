{ stdenv, fetchFromGitHub, libtool, autoconf, automake, pkgconfig
, sysfsutils
  # WARNING: DO NOT USE BEACON GENERATED VALUES AS SECRET CRYPTOGRAPHIC KEYS
  # https://www.nist.gov/programs-projects/nist-randomness-beacon
, curl ? null, libxml2 ? null, openssl ? null, withNistBeacon ? false
  # Systems that support RDRAND but not AES-NI require libgcrypt to use RDRAND as an entropy source
, libgcrypt ? null, withGcrypt ? true
  # Not sure if jitterentropy is safe to use for cryptography
  # and thus a default entropy source
, jitterentropy ? null, withJitterEntropy ? false
}:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rng-tools-${version}";
  version = "6.6";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = "rng-tools";
    rev = "v${version}";
    sha256 = "0c32sxfvngdjzfmxn5ngc5yxwi8ij3yl216nhzyz9r31qi3m14v7";
  };

  nativeBuildInputs = [ libtool autoconf automake pkgconfig ];

  preConfigure = "./autogen.sh";

  configureFlags =
       optional (!withJitterEntropy) "--disable-jitterentropy"
    ++ optional (!withNistBeacon) "--without-nistbeacon"
    ++ optional (!withGcrypt) "--without-libgcrypt";

  buildInputs = [ sysfsutils ]
    ++ optional withJitterEntropy [ jitterentropy ]
    ++ optional withGcrypt [ libgcrypt.dev ]
    ++ optional withNistBeacon [ openssl.dev curl.dev libxml2.dev ];

  enableParallelBuilding = true;

  # For cross-compilation
  makeFlags = [ "AR:=$(AR)" ];

  meta = {
    description = "A random number generator daemon";
    homepage = https://github.com/nhorman/rng-tools;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ johnazoidberg ];
  };
}
