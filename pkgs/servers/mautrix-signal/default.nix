{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "mautrix-signal";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-signal";
    rev = "v${version}";
    sha256 = "11snsl7i407855h39g1fgk26hinnq0inr8sjrgd319li0d3jwzxl";
  };

  propagatedBuildInputs = with python3Packages; [
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
      exec python -m mautrix_signal \"$@\"
    " > $out/bin/mautrix-signal
    chmod +x $out/bin/mautrix-signal
    wrapProgram $out/bin/mautrix-signal \
      --set PATH ${python3Packages.python}/bin \
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
