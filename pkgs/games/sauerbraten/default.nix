x@{builderDefsPackage
  , fetchsvn, mesa, SDL, SDL_image, SDL_mixer
  , libpng, zlib, libjpeg, imagemagick, libX11
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["fetchsvn"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="sauerbraten";
    version="3331";
    name="${baseName}-r${version}";
    url="https://svn.code.sf.net/p/sauerbraten/code";
    hash="0904hk9rz2x941c9587bfxa4rca81260j3m2hjjrp984w67x2w7y";
  };
in
rec {
  srcDrv = a.fetchsvn {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    rev = sourceInfo.version;
  };

  src = srcDrv + "/";

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["setVars" "doMakeInstall" "doCreateScripts"];

  setVars = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lX11"
  '';

  doUnpack = a.fullDepEntry ''
    mkdir -p $out/share/sauerbraten/build-dir
    ln -s  $out/share/sauerbraten/build-dir
    cd $out/share/sauerbraten/build-dir
    (cd ${src}; find . -type d) | tail -n +2 | xargs -L 1 mkdir
    (cd ${src}; find . -type f) | while read; do ln -s ${src}/"$REPLY" "$(dirname "$REPLY")"; done
    cd src
    ls
    make clean
    sed -e '/[.]h[.]gch/,/-o/s@-o@-x c++-header -o@' -i Makefile
  '' ["minInit" "addInputs" "defEnsureDir"];

  doCreateScripts = a.fullDepEntry ''
    cd ..
    mkdir -p $out/bin
    echo '#! /bin/sh' >> $out/bin/sauerbraten_server
    echo 'cd "'"$out"'/share/sauerbraten/build-dir"' >> $out/bin/sauerbraten_server
    echo './bin_unix/native_server "$@"' >> $out/bin/sauerbraten_server
    echo '#! /bin/sh' >> $out/bin/sauerbraten_client
    echo 'cd "'"$out"'/share/sauerbraten/build-dir"' >> $out/bin/sauerbraten_client
    echo './bin_unix/native_client "$@"' >> $out/bin/sauerbraten_client
    chmod a+x $out/bin/sauerbraten_*
  '' ["minInit" "defEnsureDir"];
      
  meta = {
    description = "";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      # raskin: tested amd64-linux;
      # not setting platforms because it is 0.5+ GiB of game data
      [];
    license = "freeware"; # as an aggregate - data files have different licenses
                          # code is under zlib license
  };
}) x

