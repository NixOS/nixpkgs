{ lib
, stdenv
, fetchFromGitHub
, python3
, enableSystemd ? lib.meta.availableOn stdenv.hostPlatform python3.pkgs.systemd
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mautrix-facebook";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "facebook";
    rev = "v${version}";
    hash = "sha256-8uleN7L3fgNqqRjva3kJU7fLPJZpO6b0J4z0RxZ9B64=";
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
    mainProgram = "mautrix-facebook";
  };
}
