{ stdenv
, serverEMail ? "postmaster@example.org"
, archiverKey ? "SecretArchiverAPIKey"
, allowedHosts ? []
}:

let

  allowedHostsString = stdenv.lib.concatMapStringsSep ", " (x: "\""+x+"\"") allowedHosts;

in

stdenv.mkDerivation {
  name = "mailman-web-0";

  unpackPhase = ":";

  installPhase = ''
    install -D -m 444 ${./urls.py} $out/urls.py
    install -D -m 444 ${./wsgi.py} $out/wsgi.py
    substitute ${./settings.py} $out/settings.py \
      --subst-var-by SERVER_EMAIL '${serverEMail}' \
      --subst-var-by ARCHIVER_KEY '${archiverKey}' \
      --subst-var-by ALLOWED_HOSTS '${allowedHostsString}'
    chmod 444 $out/settings.py
  '';
}
