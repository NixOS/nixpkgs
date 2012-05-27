{ stdenv, fetchgit } :
stdenv.mkDerivation {
  name = "proxychains-4.0";
  src = fetchgit {
    url = https://github.com/haad/proxychains.git;
#    sha256 = "9a27657fe9f6e17de9e402ba5c60f9954e7e79fb270c1ef242770f3c01d8515a";
  };

#  patchPhase = "sed -e s@libproxychains.so@$out/lib/libproxychains.so@ -i proxychains/proxychains";

  meta = {
    description = "Proxifier for SOCKS proxies.";
    homepage = http://proxychains.sourceforge.net;
    license = "GPLv2+";
  };
}
