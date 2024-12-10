{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  autoreconfHook,
  makeWrapper,
  perlPackages,
  coreutils,
  gnused,
  gnugrep,
}:

let
  glplugin = fetchFromGitHub {
    owner = "lausser";
    repo = "GLPlugin";
    rev = "ef3107f01afe55fad5452e64ac5bbea00b18a8d5";
    sha256 = "047fwrycsl2vmpi4wl46fs6f8y191d6qc9ms5rvmrj1dm2r828ws";
  };

  generic =
    {
      pname,
      version,
      sha256,
      description,
      buildInputs,
      ...
    }:
    stdenv.mkDerivation {
      inherit pname version;

      src = fetchurl {
        url = "https://labs.consol.de/assets/downloads/nagios/${pname}-${version}.tar.gz";
        inherit sha256;
      };

      buildInputs = [ perlPackages.perl ] ++ buildInputs;

      nativeBuildInputs = [
        autoreconfHook
        makeWrapper
      ];

      prePatch = with lib; ''
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

      meta = with lib; {
        homepage = "https://labs.consol.de/";
        license = licenses.gpl2;
        maintainers = with maintainers; [ peterhoeg ];
        inherit description;
      };
    };

in
{
  check-mssql-health = generic {
    pname = "check_mssql_health";
    version = "2.6.4.15";
    sha256 = "12z0b3c2p18viy7s93r6bbl8fvgsqh80136d07118qhxshp1pwxg";
    description = "Check plugin for Microsoft SQL Server";
    buildInputs = [ perlPackages.DBDsybase ];
  };

  check-nwc-health = generic {
    pname = "check_nwc_health";
    version = "7.10.0.6";
    sha256 = "092rhaqnk3403z0y60x38vgh65gcia3wrd6gp8mr7wszja38kxv2";
    description = "Check plugin for network equipment";
    buildInputs = [ perlPackages.NetSNMP ];
  };

  check-ups-health = generic {
    pname = "check_ups_health";
    version = "2.8.3.3";
    sha256 = "0qc2aglppwr9ms4p53kh9nr48625sqrbn46xs0k9rx5sv8hil9hm";
    description = "Check plugin for UPSs";
    buildInputs = [ perlPackages.NetSNMP ];
  };
}
