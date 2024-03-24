{
  autoreconfHook,
  coreutils,
  fetchFromGitHub,
  fetchurl,
  gnugrep,
  gnused,
  lib,
  makeWrapper,
  perlPackages,
  stdenv,
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
          --replace-fail /bin/cat  ${getExe' coreutils "cat"} \
          --replace-fail /bin/echo ${getExe' coreutils "echo"} \
          --replace-fail /bin/grep ${getExe gnugrep} \
          --replace-fail /bin/sed  ${getExe gnused}
      '';

      postInstall = ''
        if [[ -d $out/libexec ]]; then
          ln -sr $out/libexec $out/bin
        fi
      '';

      postFixup = ''
        for f in $out/bin/* ; do
          wrapProgram $f --prefix PERL5LIB : $PERL5LIB
        done
      '';

      meta = with lib; {
        homepage = "https://labs.consol.de/";
        license = licenses.gpl2Only;
        maintainers = with maintainers; [ peterhoeg ];
        inherit description;
      };
    };
in
{
  check_mssql_health = generic {
    pname = "check-mssql-health";
    version = "2.6.4.15";
    sha256 = "12z0b3c2p18viy7s93r6bbl8fvgsqh80136d07118qhxshp1pwxg";
    description = "Check plugin for Microsoft SQL Server";
    buildInputs = [ perlPackages.DBDsybase ];
  };

  check_nwc_health = generic {
    pname = "check-nwc-health";
    version = "7.10.0.6";
    sha256 = "092rhaqnk3403z0y60x38vgh65gcia3wrd6gp8mr7wszja38kxv2";
    description = "Check plugin for network equipment";
    buildInputs = [ perlPackages.NetSNMP ];
  };

  check_ups_health = generic {
    pname = "check-ups-health";
    version = "2.8.3.3";
    sha256 = "0qc2aglppwr9ms4p53kh9nr48625sqrbn46xs0k9rx5sv8hil9hm";
    description = "Check plugin for UPSs";
    buildInputs = [ perlPackages.NetSNMP ];
  };
}
