{ lib
, fetchFromGitHub
, withLdap ? true
, python3
, withPostgres ? true
, nix-update-script
, nixosTests
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      pydantic = super.pydantic_1;
    };
  };
in
python.pkgs.buildPythonPackage rec {
  pname = "etebase-server";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "server";
    rev = "refs/tags/v${version}";
    hash = "sha256-GEieXue3Kvc4zZjfypKLmTmhNPbn/GR8g0qEqkl+wkw=";
  };

  patches = [ ./secret.patch ];

  doCheck = false;

  propagatedBuildInputs = with python.pkgs; [
    aiofiles
    django_4
    fastapi
    msgpack
    pynacl
    redis
    uvicorn
    websockets
    watchfiles
    uvloop
    pyyaml
    python-dotenv
    httptools
    typing-extensions
  ] ++ lib.optional withLdap python-ldap
    ++ lib.optional withPostgres psycopg2;

  postInstall = ''
    mkdir -p $out/bin $out/lib
    cp manage.py $out/bin/etebase-server
    wrapProgram $out/bin/etebase-server --prefix PYTHONPATH : "$PYTHONPATH"
    chmod +x $out/bin/etebase-server
  '';

  passthru.updateScript = nix-update-script {};
  passthru.python = python;
  # PYTHONPATH of all dependencies used by the package
  passthru.pythonPath = python.pkgs.makePythonPath propagatedBuildInputs;
  passthru.tests = {
    nixosTest = nixosTests.etebase-server;
  };

  meta = with lib; {
    homepage = "https://github.com/etesync/server";
    description = "Etebase (EteSync 2.0) server so you can run your own";
    mainProgram = "etebase-server";
    changelog = "https://github.com/etesync/server/blob/${version}/ChangeLog.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ felschr phaer ];
  };
}
