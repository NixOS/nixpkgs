x@{builderDefsPackage
  , unzip, texLive, texLiveCMSuper, texLiveAggregationFun
  , ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    ["texLive" "texLiveCMSuper" "texLiveAggregationFun"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames))
    ++ [(a.texLiveAggregationFun {paths=[a.texLive a.texLiveCMSuper];})];
  sourceInfo = rec {
    baseName="disser";
    version="1.3.0";
    name="${baseName}-${version}";
    project="${baseName}";
    url="mirror://sourceforge/project/${project}/${baseName}/${version}/${name}.zip";
    hash="1iab3va6xw53l8xzmd83kbnzqah9f6imzzfd3c2054q53p0ndlim";
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
  phaseNames = ["setVars" "doMakeInstall"];

  setVars = a.noDepEntry ''
    export HOME="$TMPDIR"
  '';

  makeFlags = ["DESTDIR=$out/share/texmf-dist"];

  meta = {
    description = "Russian PhD thesis LaTeX package";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux; # platform-independent
    license = a.lib.licenses.free; # LaTeX Project Public License
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/disser/files/disser/";
    };
  };
}) x
