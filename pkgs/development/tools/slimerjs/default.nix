{stdenv, fetchurl, fetchgit, zip, unzip, xulrunner, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="slimerjs";
    version="0.9.2";
    name="${baseName}-${version}";
    hash="0817f3aq0gn04q4hq43xk4av02d86s2001lg5s5p38phd2jvh703";
    url="http://download.slimerjs.org/releases/0.9.2/slimerjs-0.9.2.zip";
    sha256="0817f3aq0gn04q4hq43xk4av02d86s2001lg5s5p38phd2jvh703";
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
    echo 'export SLIMERJSLAUNCHER=${xulrunner}/bin/xulrunner' >>  "$out/bin/slimerjs"
    echo "'$out/lib/slimerjs/slimerjs' \"\$@\"" >> "$out/bin/slimerjs"
    chmod a+x "$out/bin/slimerjs"
  '';
  meta = {
    inherit (s) version;
    description = ''Gecko-based programmatically-driven browser'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
