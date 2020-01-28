{ stdenv, python, hyperkitty, postorius, buildPythonPackage, isPy3k
, serverEMail ? "postmaster@example.org"
, archiverKey ? "SecretArchiverAPIKey"
, allowedHosts ? []
}:

let

  allowedHostsString = stdenv.lib.concatMapStringsSep ", " (x: "\""+x+"\"") allowedHosts;

in

# We turn those Djando configuration files into a make-shift Python library so
# that Nix users can use this package as a part of their buildInputs to import
# the code. Also, this package implicitly provides an environment in which the
# Django app can be run.

buildPythonPackage {
  name = "mailman-web-0";
  disabled = !isPy3k;

  propagatedBuildInputs = [ hyperkitty postorius ];

  unpackPhase = ":";
  buildPhase = ":";
  setuptoolsCheckPhase = ":";

  installPhase = ''
    d=$out/${python.sitePackages}
    install -D -m 444 ${./urls.py} $d/urls.py
    install -D -m 444 ${./wsgi.py} $d/wsgi.py
    substitute ${./settings.py} $d/settings.py \
      --subst-var-by SERVER_EMAIL '${serverEMail}' \
      --subst-var-by ARCHIVER_KEY '${archiverKey}' \
      --subst-var-by ALLOWED_HOSTS '${allowedHostsString}'
    chmod 444 $d/settings.py
  '';
}
