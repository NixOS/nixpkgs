{ stdenv, lib, fetchFromGitHub }:

let
  games = {
    ctf = {
      id = "ctf";
      version = "1.07";
      description = "'Capture The Flag' for Yamagi Quake II";
      sha256 = "0i9bwhjvq6yhalrsbzjambh27fdzrzgswqz3jgfn9qw6k1kjvlin";
    };

    ground-zero = {
      id = "rogue";
      version = "2.07";
      description = "'Ground Zero' for Yamagi Quake II";
      sha256 = "1m2r4vgfdxpsi0lkf32liwf1433mdhhmjxiicjwzqjlkncjyfcb1";
    };

    the-reckoning = {
      id = "xatrix";
      version = "2.08";
      description = "'The Reckoning' for Yamagi Quake II";
      sha256 = "1wp9fg1q8nly2r9hh4394r1h4dxyni3lvdy7g419cz5s8hhn5msr";
    };
  };

  toDrv = title: data: stdenv.mkDerivation rec {
    inherit (data) id version description sha256;
    inherit title;

    pname = "yquake2-${title}";

    src = fetchFromGitHub {
      inherit sha256;
      owner = "yquake2";
      repo = data.id;
      rev = "${lib.toUpper id}_${builtins.replaceStrings ["."] ["_"] version}";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/yquake2/${id}
      cp release/* $out/lib/yquake2/${id}
      runHook postInstall
    '';

    meta = with lib; {
      inherit (data) description;
      homepage = "https://www.yamagi.org/quake2/";
      license = licenses.unfree;
      platforms = platforms.unix;
      maintainers = with maintainers; [ tadfisher ];
    };
  };

in
  lib.mapAttrs toDrv games
