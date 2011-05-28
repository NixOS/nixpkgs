x@{builderDefsPackage
  , rpm, cpio, xproto, libX11, libXmu, libXaw, libXt, tcl, tk, libXext
  , makeWrapper
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="xconq";
    version="7.5.0-0pre.0.20050612";
    name="${baseName}-${version}";
    extension="src.rpm";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${baseName}/${name}/${baseName}-${version}.${extension}";
    hash="0i41dz95af2pzmmjz0sc1n0wdxy7gjqlfcl503hw1xd5zza2lw2j";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["addInputs" "doUnpack" "fixMakefiles" "fixCfiles" "doConfigure"
    "doMakeInstall" "doWrap"];
      
  doWrap = a.makeManyWrappers ''$out/bin/*'' ''--prefix TCLLIBPATH : "${tk}/lib"'';

  fixMakefiles = a.fullDepEntry ''
    find . -name 'Makefile.in' -exec sed -re 's@^        ( *)(cd|[&][&])@	\1\2@' -i '{}' ';'
    find . -name 'Makefile.in' -exec sed -e '/chown/d; /chgrp/d' -i '{}' ';'
    sed -e '/^			* *[$][(]tcltkdir[)]\/[*][.][*]/d' -i tcltk/Makefile.in
  '' ["minInit" "doUnpack"];

  fixCfiles = a.fullDepEntry ''
    sed -re 's@[(]int[)]color@(long)color@' -i tcltk/tkmap.c
  '' ["minInit" "doUnpack"];

  configureFlags = [
    "--enable-alternate-scoresdir=scores"
    "--with-tclconfig=${tcl}/lib"
    "--with-tkconfig=${tk}/lib"
  ];

  meta = {
    description = "A programmable turn-based strategy game";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
  };
}) x

