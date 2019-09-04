{ stdenv, fetchFromGitHub, fetchurl, autoreconfHook, makeWrapper
, perlPackages, coreutils, gnused, gnugrep }:

let
  glplugin = fetchFromGitHub {
    owner = "lausser";
    repo   = "GLPlugin";
    rev    = "ef3107f01afe55fad5452e64ac5bbea00b18a8d5";
    sha256 = "047fwrycsl2vmpi4wl46fs6f8y191d6qc9ms5rvmrj1dm2r828ws";
  };

  generic = { pname, version, sha256, description, buildInputs, ... }:
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://labs.consol.de/assets/downloads/nagios/${pname}-${version}.tar.bz";
      inherit sha256;
    };

    buildInputs = [ perlPackages.perl ] ++ buildInputs;

    nativeBuildInputs = [ autoreconfHook makeWrapper ];

    prePatch = with stdenv.lib; ''
      rm -rf GLPlugin
      ln -s ${glplugin} GLPlugin
      substituteInPlace plugins-scripts/Makefile.am \
        --replace /bin/cat  ${getBin coreutils}/bin/cat \
        --replace /bin/echo ${getBin coreutils}/bin/echo \
        --replace /bin/grep ${getBin gnugrep}/bin/grep \
        --replace /bin/sed  ${getBin gnused}/bin/sed
    '';

    postInstall = ''
      test -d $out/libexec && ln -sr $out/libexec $out/bin
    '';

    postFixup = ''
      for f in $out/bin/* ; do
        wrapProgram $f --prefix PERL5LIB : $PERL5LIB
      done
    '';

    meta = with stdenv.lib; {
      homepage    = https://labs.consol.de/;
      license     = licenses.gpl2;
      maintainers = with maintainers; [ peterhoeg ];
      inherit description;
    };
  };

in {
  check-mssql-health = generic {
    pname       = "check_mssql_health";
    version     = "2.6.4.14";
    sha256      = "0w6gybrs7imx169l8740s0ax3adya867fw0abrampx59mnsj5pm1";
    description = "Check plugin for Microsoft SQL Server.";
    buildInputs = [ perlPackages.DBDsybase ];
  };

  check-nwc-health = generic {
    pname       = "check_nwc_health";
    version     = "7.0.1.3";
    sha256      = "0rgd6zgd7kplx3z72n8zbzwkh8vnd83361sk9ibh6ng78sds1sl5";
    description = "Check plugin for network equipment.";
    buildInputs = [ perlPackages.NetSNMP ];
  };

  check-ups-health = generic {
    pname       = "check_ups_health";
    version     = "2.8.2.2";
    sha256      = "1gc2wjsymay2vk5ywc1jj9cvrbhs0fs851x8l4nc75df2g75v521";
    description = "Check plugin for UPSs.";
    buildInputs = [ perlPackages.NetSNMP ];
  };
}
