{ stdenv, lib, fetchFromGitHub, cmake }:

let
  games = {
    ctf = {
      id = "ctf";
      version = "1.05";
      description = "'Capture The Flag' for Yamagi Quake II";
      sha256 = "15ihspyshls645ig0gq6bwdzvghyyysqk60g6ad3n4idb2ms52md";
    };

    ground-zero = {
      id = "rogue";
      version = "2.04";
      description = "'Ground Zero' for Yamagi Quake II";
      sha256 = "0x1maaycrxv7d3xvvk1ih2zymhvcd3jnab7g3by8qh6g5y33is5l";
    };

    the-reckoning = {
      id = "xatrix";
      version = "2.05";
      description = "'The Reckoning' for Yamagi Quake II";
      sha256 = "0gf2ryhgz8nw1mb1arlbriihjsx09fa0wmkgcayc8ijignfi1qkh";
    };
  };

  toDrv = title: data: stdenv.mkDerivation rec {
    inherit (data) id version description sha256;
    inherit title;

    name = "yquake2-${title}-${version}";

    src = fetchFromGitHub {
      inherit sha256;
      owner = "yquake2";
      repo = data.id;
      rev = "${lib.toUpper id}_${builtins.replaceStrings ["."] ["_"] version}";
    };

    enableParallelBuilding = true;

    nativeBuildInputs = [ cmake ];

    installPhase = ''
      mkdir -p $out/lib/yquake2/${id}
      cp Release/* $out/lib/yquake2/${id}
    '';

    meta = with stdenv.lib; {
      inherit (data) description;
      homepage = "https://www.yamagi.org/quake2/";
      license = licenses.unfree;
      platforms = platforms.unix;
      maintainers = with maintainers; [ tadfisher ];
    };
  };

in
  lib.mapAttrs toDrv games
