{stdenv, fetchurl, fetchgit, zip, unzip, xulrunner, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="slimerjs";
    version="git-2013-10-31";
    name="${baseName}-${version}";
    hash="643a9d2f97f238bbd9debb17c010946d507a3b740079d9398939e7fdd70256b9";
    url="https://github.com/laurentj/slimerjs";
    rev="fdeb7364d3e29b47391ed0651176c1aedcb5277f";
    sha256="643a9d2f97f238bbd9debb17c010946d507a3b740079d9398939e7fdd70256b9";
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
