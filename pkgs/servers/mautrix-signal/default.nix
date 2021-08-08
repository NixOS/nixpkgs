{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonPackage rec {
  pname = "mautrix-signal";
  version = "unstable-2021-07-01";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-signal";
    rev = "56eb24412fcafb4836f29375fba9cc6db1715d6f";
    sha256 = "10nbfl48yb7h23znkxvkqh1dgp2xgldvxsigwfmwa1qbq0l4dljl";
  };

  propagatedBuildInputs = with python3.pkgs; [
    CommonMark
    aiohttp
    asyncpg
    attrs
    mautrix
    phonenumbers
    pillow
    prometheus_client
    pycryptodome
    python-olm
    python_magic
    qrcode
    ruamel_yaml
    unpaddedbase64
    yarl
  ];

  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin

    # Make a little wrapper for running mautrix-signal with its dependencies
    echo "$mautrixSignalScript" > $out/bin/mautrix-signal
    echo "#!/bin/sh
      exec python -m mautrix_signal \"\$@\"
    " > $out/bin/mautrix-signal
    chmod +x $out/bin/mautrix-signal
    wrapProgram $out/bin/mautrix-signal \
      --set PATH ${python3}/bin \
      --set PYTHONPATH "$PYTHONPATH"
  '';

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-signal";
    description = "A Matrix-Signal puppeting bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}
