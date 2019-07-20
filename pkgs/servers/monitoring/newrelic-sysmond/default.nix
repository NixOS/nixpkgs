{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "newrelic-sysmond-${version}";
  version = "2.3.0.132";

  src = fetchurl {
    url = "https://download.newrelic.com/server_monitor/archive/${version}/newrelic-sysmond-${version}-linux.tar.gz";
    sha256 = "0cdvffdsadfahfn1779zjfawz6l77awab3g9mw43vsba1568jh4f";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -v -m755 daemon/nrsysmond.x64 $out/bin/nrsysmond
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/nrsysmond
  '';

  meta = with stdenv.lib; {
    description = "System-wide monitoring for newrelic";
    homepage = https://newrelic.com/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lnl7 ];
  };
}
