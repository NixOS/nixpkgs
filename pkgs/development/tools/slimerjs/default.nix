{stdenv, fetchurl, fetchgit, zip, unzip, firefox, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="slimerjs";
    version="0.9.4";
    name="${baseName}-${version}";
    hash="0g00mb4z8z5if3sf52bad75w9xdx8p81y5p4p46c2v577v42s5z3";
    url="http://download.slimerjs.org/releases/0.9.4/slimerjs-0.9.4.zip";
    sha256="0g00mb4z8z5if3sf52bad75w9xdx8p81y5p4p46c2v577v42s5z3";
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
