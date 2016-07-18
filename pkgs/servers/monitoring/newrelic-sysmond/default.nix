{ stdenv, fetchurl }:

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "newrelic-sysmond-2.3.0.132";

  src = fetchurl {
    url = "http://download.newrelic.com/server_monitor/release/newrelic-sysmond-2.3.0.132-linux.tar.gz";
    sha256 = "0cdvffdsadfahfn1779zjfawz6l77awab3g9mw43vsba1568jh4f";
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
  };
}
