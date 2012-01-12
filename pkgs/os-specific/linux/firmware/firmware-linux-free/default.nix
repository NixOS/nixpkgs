{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "firmware-linux-free-3";

  src = fetchurl {
      url = "mirror://debian/pool/main/f/firmware-free/firmware-free_3.tar.gz";
      sha256 = "8363230e56365dd6b5e8ae9fd6cefab83472f4842f7221ffc2d890eaf7d7f1ef";
    };
 
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''ensureDir $out && cp -ra * $out/'';

  meta = {
    description = "Free kernel firmware (packaged by Debian)";
    homepage = "http://packages.debian.org/sid/firmware-linux-nonfree";
    license = "free";
    priority = "10";
  };
}
