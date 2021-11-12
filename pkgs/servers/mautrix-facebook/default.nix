{ enableSystemd ? stdenv.isLinux
, fetchFromGitHub
, lib
, python3
, stdenv
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mautrix-facebook";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "facebook";
    rev = "v${version}";
    sha256 = "0m7nznx3z6cg4wgvjybdivx22ifxcdri4i8501yibsri0jnpf0y2";
  };

  propagatedBuildInputs = with python3.pkgs; [
    CommonMark
    aiohttp
    asyncpg
    mautrix
    paho-mqtt
    pillow
    prometheus-client
    pycryptodome
    python-olm
    python_magic
    ruamel_yaml
    unpaddedbase64
    yarl
  ] ++ lib.optional enableSystemd systemd;

  doCheck = false;

  postPatch = ''
    sed -ie 's/^asyncpg.*/asyncpg>=0.20/' requirements.txt
  '';

  postInstall = ''
    mkdir -p $out/bin

    cat <<-END >$out/bin/mautrix-facebook
    #!/bin/sh
    PYTHONPATH="$PYTHONPATH" exec ${python3}/bin/python -m mautrix_facebook "\$@"
    END
    chmod +x $out/bin/mautrix-facebook
  '';

  meta = with lib; {
    homepage = "https://github.com/mautrix/facebook";
    description = "A Matrix-Facebook Messenger puppeting bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kevincox ];
  };
}
