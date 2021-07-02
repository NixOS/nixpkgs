{ stdenv, lib, fetchFromGitHub, python3Packages, makeWrapper }:

python3Packages.buildPythonPackage rec {
  pname = "seahub";
  version = "8.0.5";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "v${version}-server";
    sha256 = "0m91iby9jzldsf2avny04mvpcjkk3v45bbkk5l404g3q8z98xd5k";
  };

  dontBuild = true;
  doCheck = false; # disabled because it requires a ccnet environment

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3Packages; [
    django
    future
    django-statici18n
    django-webpack-loader
    django-simple-captcha
    django-picklefield
    django-formtools
    mysqlclient
    dateutil
    pillow
    django_compressor
    djangorestframework
    openpyxl
    requests
    requests_oauthlib
    pyjwt
    pycryptodome
    qrcode
    pysearpc
    seaserv
  ];

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
    wrapProgram $out/manage.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:" \
      --prefix PATH : "${python3Packages.python}/bin"
  '';

  meta = {
    homepage = "https://github.com/haiwen/seahub";
    description = "The web end of seafile server";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ greizgh schmittlauch ];
  };
}
