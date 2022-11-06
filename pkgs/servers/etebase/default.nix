{ lib, fetchFromGitHub, buildPythonPackage, aiofiles, django_3
, fastapi, msgpack, pynacl, redis, typing-extensions
, withLdap ? true, python-ldap
, withPostgres ? true, psycopg2 }:

buildPythonPackage rec {
  pname = "etebase-server";
  version = "0.10.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "server";
    rev = "v${version}";
    sha256 = "sha256-z6aiXSWdLcDfOpqC5epsclXWxJq59MqWDQOnnFqGwz4=";
  };

  patches = [ ./secret.patch ];

  propagatedBuildInputs = [
    aiofiles
    django_3
    fastapi
    msgpack
    pynacl
    redis
    typing-extensions
  ] ++ lib.optional withLdap python-ldap
    ++ lib.optional withPostgres psycopg2;

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
