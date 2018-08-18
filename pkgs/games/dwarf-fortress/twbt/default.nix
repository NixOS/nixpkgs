{ stdenvNoCC, fetchurl, unzip }:


stdenvNoCC.mkDerivation rec {
  name = "twbt-${version}";
  version = "6.49";
  dfVersion = "0.44.11";

  src = fetchurl {
    url = "https://github.com/mifki/df-twbt/releases/download/v${version}/twbt-${version}-linux.zip";
    sha256 = "1qjkc7k33qhxj2g18njzasccjqsis5y8zrw5vl90h4rs3i8ld9xz";
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
    maintainers = with maintainers; [ Baughn ];
    license = licenses.mit;
    platforms = platforms.linux;
    homepage = https://github.com/mifki/df-twbt;
  };
}
