{ stdenv, fetchurl, buildFHSUserEnv, runCommand, writeScript, rpmextract }:

let
  name = "plexmediaserver-${version}";
  version = "1.9.6.4429-23901a099";

  src = fetchurl {
    url = "https://downloads.plex.tv/plex-media-server/${version}/${name}.x86_64.rpm";
    sha256 = "0bmqf8b2d9h2h5q3n4ahs8y6a9aihj63rch7wd82rcr1l9xnqk9d";
  };

  shellScript = content: writeScript "script" "#!${stdenv.shell}\n${content}";

  app = runCommand name { outputs = [ "out" "db" ]; } ''
    ${rpmextract}/bin/rpmextract ${src} && mv usr $out
    f=$out/lib/plexmediaserver/Resources/com.plexapp.plugins.library.db
    cat $f > $db
    ln -fs /db $f
  '';
in

buildFHSUserEnv {
  name = "plexmediaserver";

  runScript = shellScript ''
    db=$HOME/com.plexapp.plugins.library.db
    root=${app}/lib/plexmediaserver

    if test ! -f "$db"; then
      cat ${app.db} > "$db"
    fi
    ln -s "$db" /db

    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$root exec "$root/Plex Media Server"
  '';

  meta = with stdenv.lib; {
    homepage = http://plex.tv/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      colemickens
      forkk
      lnl7
      pjones
      thoughtpolice
    ];
    description = "Media library streaming server";
    longDescription = ''
      Plex is a media server which allows you to store your media and play it
      back across many different devices.
    '';
  };
}
