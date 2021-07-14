{ stdenv, lib, fetchurl, ruby, bundlerEnv }:

let
  rubyEnv = bundlerEnv {
    name = "snmpcheck-ruby-env";
    gemdir = ./.;
    postBuild = ''
      ln -sf ${ruby}/bin/* $out/bin
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "snmpcheck";
  version = "1.9";
  src = fetchurl {
    url = "https://www.nothink.org/codes/snmpcheck/snmpcheck-${version}.rb";
    sha256 = "sha256-KY1/Blr1dECwrwKbAVrb1xWXroksrwzqO/SxQpPumkI=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/snmp-check

    substituteInPlace "$out/bin/snmp-check" \
      --replace "#!/usr/bin/env ruby" "#!${rubyEnv}/bin/ruby"
    chmod +x $out/bin/snmp-check
  '';

  meta = with lib; {
    description = "SNMP enumerator";
    homepage = "https://www.nothink.org/codes/snmpcheck/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ elohmeier ];
  };
}
