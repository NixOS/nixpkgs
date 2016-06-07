{stdenv, fetchurl, python, pythonPackages, makeWrapper, seafile}:

stdenv.mkDerivation rec {
  version = "5.1.2";
  name = "seafile-seahub-${version}";

  src = fetchurl {
    url = "https://github.com/haiwen/seahub/archive/v${version}-server.tar.gz";
    sha256 = "1k3y803p8fpnxqv6a90akcfb3b1brgli85p4pkvl87299k8gid83";
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
