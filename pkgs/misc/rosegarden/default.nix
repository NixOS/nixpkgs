x@{builderDefsPackage
  , automake, pkgconfig, libX11, libSM, imake, qt4, alsaLib, jackaudio
  , ladspaH, liblrdf, dssi, liblo, fftwSinglePrec, libsndfile, libsamplerate
  , xproto, libICE, perl, makedepend, librdf_raptor, lilypond, flac, libunwind
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="rosegarden";
    version="10.10";
    project="${baseName}";
    name="${baseName}-${version}";
    url="mirror://sourceforge/project/${project}/${baseName}/${version}/${name}.tar.bz2";
    hash="1ia74kzkw1yr3h8q4lrccx49hcy2961rni3h4css7r6hdl9xq909";
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
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  configureFlags = [
    "--with-qtdir=${qt4}"
  ];

  setVars = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lz -ldl -lX11"
  '';

  meta = {
    description = "A music editor and MIDI sequencer";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/rosegarden/files/rosegarden/";
    };
  };
}) x

