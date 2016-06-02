{ stdenv, fetchgit } :
stdenv.mkDerivation {
  name = "proxychains-4.0.1-head";
  src = fetchgit {
    url = https://github.com/haad/proxychains.git;
    rev = "c9b8ce35b24f9d4e80563242b759dff54867163f";
    sha256 = "163h3d3lpglbzjadf8a9kfaf0i1ds25r7si6ll6d5khn1835zik5";
  };

  meta = {
    description = "Proxifier for SOCKS proxies";
    homepage = http://proxychains.sourceforge.net;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
