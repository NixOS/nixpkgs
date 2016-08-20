{stdenv, fetchurl, python, pythonPackages, makeWrapper, seafile}:

stdenv.mkDerivation rec {
  version = "5.1.4";
  name = "seafile-seahub-${version}";

  src = fetchurl {
    url = "https://github.com/haiwen/seahub/archive/v${version}-server.tar.gz";
    sha256 = "1cd6425abi8h8xdsjch7mkdpkfi3k5pyl2p1qrnkq4ivfqs7hay6";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with pythonPackages; [ dateutil memcached chardet six pillow django_1_8 django_compressor djangorestframework openpyxl pytz sqlite3 djblets django_statici18n django_jsonfield django_constance django_post_office django_picklefield flup gunicorn ] ++ [ seafile ];

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
    wrapProgram $out/manage.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:" \
      --prefix PATH : "${python}/bin"
  '';

  meta = {
    homepage = "https://github.com/haiwen/seahub";
    description = "The web end of seafile server";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.hhhorn ];
  };
}
