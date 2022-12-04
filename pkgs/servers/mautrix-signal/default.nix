{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonPackage rec {
  pname = "mautrix-signal";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-UbetU1n9zD/mVFaJc9FECDq/Zell1TI/aYPsGXGB8Js=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    CommonMark
    aiohttp
    asyncpg
    attrs
    mautrix
    phonenumbers
    pillow
    prometheus-client
    pycryptodome
    python-olm
    python-magic
    qrcode
    ruamel-yaml
    unpaddedbase64
    yarl
  ];

  doCheck = false;

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "asyncpg>=0.20,<0.26" "asyncpg>=0.20" \
      --replace "mautrix>=0.16.0,<0.17" "mautrix>=0.16.0"
  '';

  postInstall = ''
    mkdir -p $out/bin

    # Make a little wrapper for running mautrix-signal with its dependencies
    echo "$mautrixSignalScript" > $out/bin/mautrix-signal
    echo "#!/bin/sh
      exec python -m mautrix_signal \"\$@\"
    " > $out/bin/mautrix-signal
    chmod +x $out/bin/mautrix-signal
    wrapProgram $out/bin/mautrix-signal \
      --prefix PATH : "${python3}/bin" \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with lib; {
    homepage = "https://github.com/mautrix/signal";
    description = "A Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}
