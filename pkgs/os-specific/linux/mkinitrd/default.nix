{stdenv, fetchurl, popt}:

# Red Hat mkinitrd

stdenv.mkDerivation {
  builder = ./builder.sh;
  name = "mkinitrd-4.2.15";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~armijn/.nix/mkinitrd-4.2.15.tar.bz2;
    md5 = "2f707784c460613357343ab5ce8b3aad";
  };

  buildInputs = [popt];
}
