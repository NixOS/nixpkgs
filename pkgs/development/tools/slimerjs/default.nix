{stdenv, fetchurl, fetchgit, zip, unzip, xulrunner, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="slimerjs";
    version="git-2013-11-25";
    name="${baseName}-${version}";
    hash="8c9c518085760a681e3d112ef638473861c1ab2abf9d31043fe365c5d96d3c40";
    url="https://github.com/laurentj/slimerjs";
    rev="fab60f799eb24a8ba1cad42841d4148181acb72e";
    sha256="8c9c518085760a681e3d112ef638473861c1ab2abf9d31043fe365c5d96d3c40";
  };
  buildInputs = [
    unzip zip
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  # src = fetchurl {
  #   inherit (s) url sha256;
  # };
  src = fetchgit {
    inherit (s) url sha256 rev;
  };
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
