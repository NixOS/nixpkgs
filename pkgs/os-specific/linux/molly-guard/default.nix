{ stdenv, fetchurl, dpkg, busybox, systemd }:

stdenv.mkDerivation rec {
  pname = "molly-guard";
  version = "0.6.3";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+source/molly-guard/${version}/+build/8892607/+files/molly-guard_${version}_all.deb";
    sha256 = "1d1x60m6kh9wfh9lc22g5s0j40aivwgsczykk27ymwl1pvk58dxn";
  };

  buildInputs = [ dpkg ];

  sourceRoot = ".";

  unpackCmd = ''
    dpkg-deb -x "$src" .
  '';

  installPhase = ''
    sed -i "s|/lib/molly-guard|${systemd}/sbin|g" lib/molly-guard/molly-guard
    sed -i "s|run-parts|${busybox}/bin/run-parts|g" lib/molly-guard/molly-guard
    sed -i "s|/etc/molly-guard/|$out/etc/molly-guard/|g" lib/molly-guard/molly-guard
    cp -r ./ $out/
  '';

  postFixup = ''
    for modus in init halt poweroff reboot runlevel shutdown telinit; do
       ln -sf $out/lib/molly-guard/molly-guard $out/bin/$modus;
    done;
  '';

  meta = with stdenv.lib; {
    description = "Attempts to prevent you from accidentally shutting down or rebooting machines";
    homepage    = https://anonscm.debian.org/git/collab-maint/molly-guard.git/;
    license     = licenses.artistic2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ DerTim1 ];
    priority    = -10;
  };
}
