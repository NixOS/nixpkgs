{ stdenv, fetchFromGitHub, fetchurl, buildPerlPackage, autoreconfHook, makeWrapper
, perl, NetSNMP, coreutils, gnused, gnugrep }:

let
  glplugin = fetchFromGitHub {
    owner = "lausser";
    repo   = "GLPlugin";
    rev    = "e8e1a2907a54435c932b3e6c584ba1d679754849";
    sha256 = "0wb55a9pmgbilfffx0wkiikg9830qd66j635ypczqp4basslpq5b";
  };

  generic = { pname, version, sha256, description, ... } @ attrs:
  let
    attrs' = builtins.removeAttrs attrs [ "pname" "version" "rev" "sha256"];
    name' = "${stdenv.lib.replaceStrings [ "-" ] [ "_" ] "${pname}"}-${version}";
  in perl.stdenv.mkDerivation rec {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "https://labs.consol.de/assets/downloads/nagios/${name'}.tar.gz";
      inherit sha256;
    };

    buildInputs = [ perl NetSNMP ];

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
  check-nwc-health = generic {
    pname       = "check_nwc_health";
    version     = "7.0.1.3";
    sha256      = "0rgd6zgd7kplx3z72n8zbzwkh8vnd83361sk9ibh6ng78sds1sl5";
    description = "Check plugin for network equipment.";
  };

  check-ups-health = generic {
    pname       = "check_ups_health";
    version     = "2.8.2.2";
    sha256      = "1gc2wjsymay2vk5ywc1jj9cvrbhs0fs851x8l4nc75df2g75v521";
    description = "Check plugin for UPSs.";
  };
}
