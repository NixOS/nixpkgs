{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "hddtemp-0.3_beta15";

  db = fetchurl{
    url = mirror://savannah/hddtemp/hddtemp.db;
    sha256 = "1fr6qgns6qv7cr40lic5yqwkkc7yjmmgx8j0z6d93csg3smzhhya";
  };

  src = fetchurl {
    url = mirror://savannah/hddtemp/hddtemp-0.3-beta15.tar.bz2;
    sha256 = "0nzgg4nl8zm9023wp4dg007z6x3ir60rwbcapr9ks2al81c431b1";
  };

  # from Gentoo
  patches = [ ./byteswap.patch ./dontwake.patch ./execinfo.patch ./satacmds.patch ];

  configurePhase =
    ''
      mkdir -p $out/nix-support
      cp $db $out/nix-support/hddtemp.db
      ./configure --prefix=$out --with-db-path=$out/nix-support/hddtemp.db
    '';

  meta = with stdenv.lib; {
    description = "Tool for displaying hard disk temperature";
    homepage = https://savannah.nongnu.org/projects/hddtemp/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
