{ stdenv, fetchFromGitHub, buildPerlPackage, autoreconfHook, makeWrapper
, perl, NetSNMP, coreutils, gnused, gnugrep }:

let
  owner = "lausser";

  glplugin = fetchFromGitHub {
    repo   = "GLPlugin";
    rev    = "b92a261ca4bf84e5b20d3025cc9a31ade03c474b";
    sha256 = "0kflnmpjmklq8fy2vf2h8qyvaiznymdi09z2h5qscrfi51xc9gmh";
    inherit owner;
  };

  generic = { pname, version, rev, sha256, description, ... } @ attrs:
  let
    attrs' = builtins.removeAttrs attrs [ "pname" "version" "rev" "sha256"];
  in perl.stdenv.mkDerivation rec {
    name = stdenv.lib.replaceStrings [ "-" ] [ "_" ] "${pname}-${version}";

    src = fetchFromGitHub {
      repo   = pname;
      inherit owner rev sha256;
    };

    buildInputs = [ perl NetSNMP ];

    nativeBuildInputs = [ autoreconfHook makeWrapper ];

    prePatch = with stdenv.lib; ''
      ln -s ${glplugin}/* GLPlugin
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
      homepage   = https://labs.consol.de/;
      license    = licenses.gpl2;
      maintainer = with maintainers; [ peterhoeg ];
      inherit description;
    };
  };

in {
  check-nwc-health = generic {
    pname       = "check_nwc_health";
    version     = "20170804";
    rev         = "e959b412b5cf027c82a446668e026214fdcf8df3";
    sha256      = "11l74xw62g15rqrbf9ff2bfd5iw159gwhhgbkxwdqi8sp9j6navk";
    description = "Check plugin for network equipment.";
  };

  check-ups-health = generic {
    pname       = "check_ups_health";
    version     = "20170804";
    rev         = "32a8a359ea46ec0d6f3b7aea19ddedaad63b04b9";
    sha256      = "05na48dxfxrg0i9185j1ck2795p0rw1zwcs8ra0f14cm0qw0lp4l";
    description = "Check plugin for UPSs.";
  };
}
