{ stdenv, fetchurl, buildFHSUserEnv, runCommand, writeScript, rpmextract }:

let
  name = "plexmediaserver-${version}";
  version = "1.14.1.5488-cc260c476";

  src = fetchurl {
    url = "https://downloads.plex.tv/plex-media-server/${version}/${name}.x86_64.rpm";
    sha256 = "0h2w5xqw8r9iinbibdwj8bi7vb72yzhvna5hrb8frp6fbkrhds4f";
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
