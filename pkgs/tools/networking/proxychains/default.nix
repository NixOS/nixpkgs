{ stdenv, fetchgit } :
stdenv.mkDerivation {
  name = "proxychains-4.0.1-head";
  src = fetchgit {
    url = https://github.com/haad/proxychains.git;
    rev = "c9b8ce35b24f9d4e80563242b759dff54867163f";
    sha256 = "4ab73e14c5db6d32d88e0710a9f1b7c9c77b59574a7cf0e9f69f34d8ec9fb643";
  };

  meta = {
    description = "Proxifier for SOCKS proxies";
    homepage = http://proxychains.sourceforge.net;
    license = "GPLv2+";
  };
}
