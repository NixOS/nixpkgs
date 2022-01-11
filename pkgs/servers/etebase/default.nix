{ lib, stdenv, python3, fetchFromGitHub }:

let
  py = python3.override {
    packageOverrides = self: super: {
      django = super.django_3;
    };
  };
in
  with py.pkgs;

buildPythonPackage rec {
  pname = "etebase-server";
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "server";
    rev = "v${version}";
    sha256 = "1r2a7ki9w2h3l6rwqa3fzxjlqfj2lbgfrm8lynjhvcdv02s5abbi";
  };

  patches = [ ./secret.patch ];

  propagatedBuildInputs = with pythonPackages; [
    asgiref
    cffi
    django
    django-cors-headers
    djangorestframework
    drf-nested-routers
    msgpack
    psycopg2
    pycparser
    pynacl
    pytz
    six
    sqlparse
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp -r . $out/lib/etebase-server
    ln -s $out/lib/etebase-server/manage.py $out/bin/etebase-server
    wrapProgram $out/bin/etebase-server --prefix PYTHONPATH : "$PYTHONPATH"
    chmod +x $out/bin/etebase-server
  '';

  meta = with lib; {
    homepage = "https://github.com/etesync/server";
    description = "An Etebase (EteSync 2.0) server so you can run your own.";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ felschr ];
  };
}
