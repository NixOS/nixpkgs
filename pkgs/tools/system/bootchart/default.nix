{stdenv, fetchurl, gnutar, gzip, coreutils, utillinux, gnugrep, gnused, psmisc, nettools}:

stdenv.mkDerivation rec {
  name = "bootchart-0.9";

  src = fetchurl {
    url = "mirror://sourceforge/bootchart/${name}.tar.bz2";
    sha256 = "0z9jvi7cyp3hpx6hf1fyaa8fhnaz7aqid8wrkwp29cngryg3jf3p";
  };

  buildInputs = [ gnutar gzip coreutils utillinux gnugrep gnused psmisc nettools ];

  patchPhase = ''
    export MYPATH=
    for i in $buildInputs; do
       export MYPATH=''${MYPATH}''${MYPATH:+:}$i/bin:$i/sbin
    done

    sed -i -e 's,PATH.*,PATH='$MYPATH, \
       -e 's,^CONF.*,CONF='$out/etc/bootchartd.conf, \
      script/bootchartd
  '';

  installPhase = ''
    ensureDir $out/sbin $out/etc
    cp script/bootchartd $out/sbin
    cp script/bootchartd.conf $out/etc
    chmod +x $out/sbin/bootchartd
  '';

  meta = {
    homepage = http://www.bootchart.org/;
    description = "Performance analysis and visualization of the GNU/Linux boot process";
    license="GPLv2+";
  };

}
