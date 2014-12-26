{ stdenv, fetchurl }:

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "newrelic-sysmond-1.5.1.93";

  src = fetchurl {
    url = "http://download.newrelic.com/server_monitor/release/newrelic-sysmond-1.5.1.93-linux.tar.gz";

    sha256 = "1bfwyczcf7pvji8lx566jxgy8dhyf1gmqmi64lj10673a86axnwz";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -v -m755 daemon/nrsysmond.x64 $out/bin/nrsysmond
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/nrsysmond
  '';

  meta = {
    homepage = http://newrelic.com/;

    description = "System-wide monitoring for newrelic";

    license = stdenv.lib.licenses.unfree;

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
