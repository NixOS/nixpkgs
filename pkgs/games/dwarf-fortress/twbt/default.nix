{ stdenvNoCC, lib, fetchurl, unzip
, dfVersion
}:

with lib;

let
  twbt-releases = builtins.fromJSON (builtins.readFile ./twbt.json);

  release = if hasAttr dfVersion twbt-releases
            then getAttr dfVersion twbt-releases
            else throw "[TWBT] Unsupported Dwarf Fortress version: ${dfVersion}";

  warning = if release.prerelease then builtins.trace "[TWBT] Version ${version} is a prerelease. Careful!"
                                  else null;

in

stdenvNoCC.mkDerivation rec {
  name = "twbt-${version}";
  version = release.twbtRelease;

  src = fetchurl {
    url = "https://github.com/mifki/df-twbt/releases/download/v${version}/twbt-${version}-linux.zip";
    sha256 = release.sha256;
  };

  sourceRoot = ".";

  outputs = [ "lib" "art" "out" ];

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $lib/hack/{plugins,lua} $art/data/art
    cp -a */twbt.plug.so $lib/hack/plugins/
    cp -a *.lua $lib/hack/lua/
    cp -a *.png $art/data/art/
  '';

  meta = with stdenvNoCC.lib; {
    description = "A plugin for Dwarf Fortress / DFHack that improves various aspects the game interface.";
    maintainers = with maintainers; [ Baughn numinit ];
    license = licenses.mit;
    platforms = platforms.linux;
    homepage = https://github.com/mifki/df-twbt;
  };
}
