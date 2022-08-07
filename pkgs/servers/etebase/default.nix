{ lib, fetchFromGitHub, buildPythonPackage, aioredis, aiofiles, django_3
, fastapi, msgpack, pynacl, typing-extensions
, withLdap ? true, ldap }:

buildPythonPackage rec {
  pname = "etebase-server";
  version = "0.9.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "server";
    rev = "v${version}";
    sha256 = "sha256-mYXy0N7ohNk3K2XNB6JvULF6lhL5dV8yBvooR6RuV1E=";
  };

  patches = [ ./secret.patch ];

  propagatedBuildInputs = [
    aioredis
    aiofiles
    django_3
    fastapi
    msgpack
    pynacl
    typing-extensions
  ] ++ lib.optional withLdap ldap;

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
