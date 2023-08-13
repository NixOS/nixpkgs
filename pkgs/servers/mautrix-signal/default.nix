{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonPackage rec {
  pname = "mautrix-signal";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "signal";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-QShyuwHiWRcP1hGkvCQfixvoUQ/FXr2DYC5VrcMKX48=";
  };

  postPatch = ''
    # the version mangling in mautrix_signal/get_version.py interacts badly with pythonRelaxDepsHook
    substituteInPlace setup.py \
      --replace 'version=version' 'version="${version}"'
  '';

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "mautrix"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    commonmark
    aiohttp
    aiosqlite
    asyncpg
    attrs
    commonmark
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
