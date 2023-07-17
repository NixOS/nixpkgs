{ lib
, stdenv
, fetchFromGitHub
, python3
, enableSystemd ? lib.meta.availableOn stdenv.hostPlatform python3.pkgs.systemd
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mautrix-facebook";
  version = "unstable-2023-07-16";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "facebook";
    rev = "543b50e73918918d1fabac67891dd80d97080942";
    hash = "sha256-Y6nwryPenNQa68Rh2KPUHQrv6rnapj8x19FdgLXutm8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    commonmark
    aiohttp
    asyncpg
    commonmark
    mautrix
    paho-mqtt
    pillow
    prometheus-client
    pycryptodome
    python-olm
    python-magic
    ruamel-yaml
    unpaddedbase64
    yarl
    zstandard
  ] ++ lib.optional enableSystemd systemd;

  postPatch = ''
    # Drop version limiting so that every dependency update doesn't break this package.
    sed -i -e 's/,<.*//' requirements.txt
  '';

  postInstall = ''
    mkdir -p $out/bin

    cat <<-END >$out/bin/mautrix-facebook
    #!/bin/sh
    PYTHONPATH="$PYTHONPATH" exec ${python3}/bin/python -m mautrix_facebook "\$@"
    END
    chmod +x $out/bin/mautrix-facebook
  '';

  checkPhase = ''
    $out/bin/mautrix-facebook --help
  '';

  meta = with lib; {
    homepage = "https://github.com/mautrix/facebook";
    changelog = "https://github.com/mautrix/facebook/releases/tag/v${version}";
    description = "A Matrix-Facebook Messenger puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kevincox ];
  };
}
