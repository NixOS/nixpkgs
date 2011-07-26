{ stdenv, fetchurl, pkgconfig, dbus, libcap }:

stdenv.mkDerivation rec {
  name = "rtkit-0.10";
  
  src = fetchurl {
    url = "http://0pointer.de/public/${name}.tar.gz";
    sha256 = "08118ya3pkxd6gbbshas23xwj483169fqmxzhp5sgmfr16n97skl";
  };

  buildInputs = [ pkgconfig dbus libcap ];
  
  meta = {
    homepage = http://0pointer.de/blog/projects/rtkit;
    descriptions = "A daemon that hands out real-time priority to processes";
  };
}
