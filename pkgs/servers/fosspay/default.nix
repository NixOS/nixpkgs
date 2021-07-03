{ stdenv, lib, writeText, python3, fetchFromSourcehut, conf ? null }:
let
  py3 = python3.withPackages(ps: with ps; [
    stripe
    flask
    jinja2
    flask_login
    psycopg2
    bcrypt
    sqlalchemy-utils
    pystache
    gunicorn
  ]);

in stdenv.mkDerivation {
  pname = "fosspay";
  version = "unstable-2020-12-02";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "fosspay";
    rev = "3b957a1b964f1d741876e5efe187d0c4cbb9443e";
    sha256 = "0bgdqiasb7jvpmg0p7c4hs97f05iq8w1k1cdgxwl1rx5dg9brn5v";
  };

  postPatch = lib.optionalString (conf != null) ''
    sed -i s:config.ini:${conf}:g cronjob.py
    sed -i s:config.ini:${conf}:g fosspay/config.py
  '';


  installPhase = ''
    mkdir -p $out/bin $out/share
    [ -f config.ini ] || cp config.ini.example config.ini
    cp -r * $out/share
    cat > $out/bin/fosspay << EOF
    #!/bin/sh
    cd $out/share
    ${py3}/bin/python3 $out/share/app.py
    EOF
    chmod +x $out/bin/fosspay
    cp ${py3}/bin/gunicorn $out/bin/gunicorn
  '';

  meta = with lib; {
    description = "Donation collection for FOSS groups and individuals.";
    homepage = "https://git.sr.ht/~sircmpwn/fosspay";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ pniedzwiedzinski ];
  };
}
