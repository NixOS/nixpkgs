{stdenv, fetchurl, fetchgit, zip, unzip, firefox, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="slimerjs";
    version="0.9.6";
    name="${baseName}-${version}";
    hash="0wry296iv63bmvm3qbkbgk42nbs80cbir0kv27v0ah5f6kvjc9cq";
    url="http://download.slimerjs.org/releases/0.9.6/slimerjs-0.9.6.zip";
    sha256="0wry296iv63bmvm3qbkbgk42nbs80cbir0kv27v0ah5f6kvjc9cq";
  };
  buildInputs = [
    unzip zip
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
   src = fetchurl {
     inherit (s) url sha256;
   };
  #src = fetchgit {
  #  inherit (s) url sha256 rev;
  #};
  preConfigure = ''
    test -d src && cd src
    test -f omni.ja || zip omni.ja -r */
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/slimerjs,lib/slimerjs}
    cp LICENSE README* "$out/share/doc/slimerjs"
    cp -r * "$out/lib/slimerjs"
    echo '#!${bash}/bin/bash' >>  "$out/bin/slimerjs"
    echo 'export SLIMERJSLAUNCHER=${firefox}/bin/firefox' >>  "$out/bin/slimerjs"
    echo "'$out/lib/slimerjs/slimerjs' \"\$@\"" >> "$out/bin/slimerjs"
    chmod a+x "$out/bin/slimerjs"
    sed -e 's@MaxVersion=3[0-9][.]@MaxVersion=40.@' -i "$out/lib/slimerjs/application.ini"
  '';
  meta = {
    inherit (s) version;
    description = ''Gecko-based programmatically-driven browser'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
