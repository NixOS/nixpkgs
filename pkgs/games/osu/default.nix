{ appimageTools, stdenv, lib, fetchurl }:
let
  name = "osu";
  version = "2020.806.0";

  src = fetchurl {
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
    sha256 = "04a1sskp0h9bakvx79n0nay77kp6liadahhycr0pgjfhyy7wwk47";
  };

  unpacked = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    install -m 444 -D ${unpacked}/osu!.desktop $out/share/applications/osu!.desktop
    install -m 444 -D ${unpacked}/osu!.png $out/share/applications/osu!.png
  '';

  extraPkgs = pkgs: [ pkgs.icu ];

  meta = with lib; {
    description = "rhythm is just a click away";
    homepage = "https://osu.ppy.sh";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cab404 ];
  };

}
