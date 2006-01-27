{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "quake3demo-1.11-6";
  builder = ./builder.sh;

  # This is needed for pak0.pk3.
  demo = fetchurl {
    url = http://linuv.uv.es/mirror/gentoo/distfiles/linuxq3ademo-1.11-6.x86.gz.sh;
    md5 = "484610c1ce34272223a52ec331c99d5d";
  };

  # This is needed for the additional pak?.pk3 files.
  update = fetchurl {
    url = http://linuv.uv.es/mirror/gentoo/distfiles/linuxq3apoint-1.31.x86.run;
    md5 = "2620b9eefb6d0775f766b6570870157a";
  };
  
}
