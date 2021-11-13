{ stdenv, lib, fetchFromGitHub, python3Packages, makeWrapper }:

python3Packages.buildPythonPackage rec {
  pname = "seahub";
  version = "8.0.7";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "4f7bb3f617dd847cf0a6b33c0bfb567b44c06059"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "09d05sxly1bljxxzm77limhwsbg8c4b54fzv3kmaih59pjnjyr03";
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
    pillow
    python-dateutil
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

  meta = with lib; {
    homepage = "https://github.com/haiwen/seahub";
    description = "The web end of seafile server";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
