{stdenv, fetchurl, fetchgit, fetchFromGitHub, zip, unzip, firefox, bash}:
let
  s = # Generated upstream information
  rec {
    baseName="slimerjs";
    version="0.10.3";
    name="${baseName}-${version}";
    owner = "laurentj";
    repo = "${baseName}";
    sha256="16v6a1kcq8il4snbrgsq5xmxs35alzf4qlmscr2yli95xq5fnl5y";
    rev = "${version}";
  };
  buildInputs = [
    unzip zip
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  #src = fetchurl {
  #  inherit (s) url sha256;
  #};
  #src = fetchgit {
  #  inherit (s) url sha256 rev;
  #};
  src = fetchFromGitHub {
    inherit (s) owner repo rev sha256;
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
    echo 'export SLIMERJSLAUNCHER=${firefox}/bin/firefox' >>  "$out/bin/slimerjs"
    echo "'$out/lib/slimerjs/slimerjs' \"\$@\"" >> "$out/bin/slimerjs"
    chmod a+x "$out/bin/slimerjs"
    sed -e 's@MaxVersion=[3456][0-9][.]@MaxVersion=99.@' -i "$out/lib/slimerjs/application.ini"
  '';
  meta = {
    inherit (s) version;
    description = ''Gecko-based programmatically-driven browser'';
    license = stdenv.lib.licenses.mpl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
