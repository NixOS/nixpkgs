{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "curl-7.12.0";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix//curl-7.12.0.tar.bz2;
    md5 = "47db6619b849600ba2771074f00da517";
  };
  buildInputs = [zlib];
  patches = [./configure-cxxcpp.patch];
  configureFlags = "--without-ssl";
}
