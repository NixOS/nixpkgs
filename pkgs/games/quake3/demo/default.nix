{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "quake3demo-1.11-6";
  builder = ./builder.sh;

  # This is needed for pak0.pk3.
  demo = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/linuxq3ademo-1.11-6.x86.gz.sh;
    md5 = "484610c1ce34272223a52ec331c99d5d";
  };

  # This is needed for the additional pak?.pk3 files.
  update = fetchurl {
    url = http://www.dev1ance.net/files/quake3/point_release/linux/linuxq3apoint-1.31.x86.run;
    sha256 = "1n6mk2x99vl40br1zvwvdl8fs8ldsbi7byf7wj385g1xywzvqqr8";
  };
  
}
