{ fetchurl, lib, meta, pname, stdenvNoCC, undmg, version }:

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://cdn.akamai.steamstatic.com/client/installer/steam.dmg";
    sha256 = "0pja22z5vbf3v7gmb0l1mjqv9dliz0qiq9ss7w5m1114fzvq39gk";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r "Steam.app" "$out/Applications"
  '';

  meta = meta // {
    platforms = [ "x86_64-darwin" ];
    maintainers = with lib.maintainers; [ steinybot ];
  };

  passthru.run = throw "steam-run is not supported on Darwin.";
}
