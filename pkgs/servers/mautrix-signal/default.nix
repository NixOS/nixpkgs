{ lib, python3, fetchFromGitHub }:

let
  python = python3.override {
    packageOverrides = self: super: {
      mautrix = super.mautrix.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.18";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "32daf7a7dcf5d4013b37321df7b319f36523f38884ccc3e2e965917d0a5c73c1";
        };
      });
    };
  };
in python.pkgs.buildPythonPackage rec {
  pname = "mautrix-signal";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-signal";
    rev = "v${version}";
    sha256 = "11snsl7i407855h39g1fgk26hinnq0inr8sjrgd319li0d3jwzxl";
  };

  propagatedBuildInputs = with python.pkgs; [
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
      --set PATH ${python}/bin \
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
