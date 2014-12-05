{stdenv, fetchurl, fetchgit, zip, unzip, firefox, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="slimerjs";
    version="0.9.3";
    name="${baseName}-${version}";
    hash="17vfnz6njn8zk39ywpg7bd9wp98ppxjvna6gn2443ylgh428v707";
    url="http://download.slimerjs.org/releases/0.9.3/slimerjs-0.9.3.zip";
    sha256="17vfnz6njn8zk39ywpg7bd9wp98ppxjvna6gn2443ylgh428v707";
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
    sed -e 's@MaxVersion=32[.]@MaxVersion=33.@' -i "$out/lib/slimerjs/application.ini"
  '';
  meta = {
    inherit (s) version;
    description = ''Gecko-based programmatically-driven browser'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
