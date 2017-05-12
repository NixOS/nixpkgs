{ stdenv, fetchFromGitHub, pkgs, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "taiga-back";
  version = "3.1.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "taigaio";
    repo = "taiga-back";
    rev = "${version}";
    sha256 = "13kdh69lzz81076wp7vddaxwq08vkl6abjp63pa7szdh5bgrqsr3";
  };

# all python dependencies taken from requirements.txt
# TODO are all of these (explicitly) required ?
  propagatedBuildInputs = with python3Packages; [
    pkgs.gettext
    amqp
    asana    
    bleach
    cairosvg
    celery
    cryptography
    cssutils
    dateutil
    diff-match-patch
    django
    django-ipware
    django-jinja
    django-pglocks
    django-picklefield
    django-sampledatahelper
    django-sites
    django-sr
    djmail
    easy-thumbnails
    fn
    gunicorn
    html5lib
    jinja2
    lxml
    markdown
    netaddr
    pillow
    premailer
    psd-tools
    psycopg2
    pygments
    pyjwkest
    pyjwt
    python_magic
    pytz
    raven
    redis
    requests
    requests_oauthlib
    serpy
    six
    unidecode
    webcolors
  ];

  patches = [
    ./taiga-back-setup-py.patch
  ];

  postPatch = ''
    sed -i 's/html5lib.serializer.htmlserializer/html5lib.serializer/' taiga/mdrender/service.py
  '';

  postFixup = ''
    wrapPythonProgramsIn $out/bin/manage.py

    #HACK wrapper breaks django manage.py
    sed -i "$out/bin/.manage.py-wrapped" -e '
      0,/sys.argv\[0\].*;/s/sys.argv\[0\][^;]*;//
    '
  '';

  meta = {
    description = "Project management web application with scrum in mind! Built on top of Django and AngularJS (Backend Code)";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.agpl3;
  };
}
