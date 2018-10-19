{ stdenv, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "Weblate";
  version = "3.2.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0xm2vpfvdyxivjlc222fnm0xq5f9fm6nhmyimdxsqlmr9i6zfvlv";
  };

  # https://docs.weblate.org/en/latest/admin/install.html#install
  propagatedBuildInputs = with python3.pkgs; [
    django
    celery
    celery-batches
    siphashc
    translate-toolkit
    six
    filelock
    social-auth-core
    social-auth-app-django
    django_appconf
    whoosh
    pillow
    lxml
    defusedxml
    dateutil
    django_compressor
    django-crispy-forms
    djangorestframework
    user-agents
    pyuca
    Babel
    phply
    pytz
    python-bidi
    akismet
    pyyaml
    jellyfish
    openpyxl
    zeep
    psycopg2
  ];

  checkInputs = with python3.pkgs; [
    httpretty
    selenium
    boto3
  ];

  doCheck = false; # tests not included on PyPI (https://github.com/WeblateOrg/weblate/issues/2334)

  meta = with stdenv.lib; {
    description = "Web based translation tool with tight version control integration";
    homepage = https://weblate.org/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
  };
}
