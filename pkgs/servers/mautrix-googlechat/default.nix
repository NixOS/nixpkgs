{ fetchFromGitHub
, fetchpatch
, lib
, python3
, enableE2be ? true
, enableMetrics ? true
, enableSqlite ? true
}: python3.pkgs.buildPythonApplication rec {
  pname = "mautrix-googlechat";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "googlechat";
    rev = "refs/tags/v${version}";
    hash = "sha256-a/EWz/aCkBE6XdDpmZcx2Q7/xKNwGCiZUhZc9YIIDhU=";
  };

  patches = [
    (fetchpatch {
      # patch setup.py to generate $out/bin/mautrix-googlechat
      # https://github.com/mautrix/googlechat/pull/81
      name = "mautrix-googlechat-entry-point.patch";
      url = "https://github.com/mautrix/googlechat/pull/81/commits/112fa3d27bc6f89a02321cb80d219de149e00df8.patch";
      sha256 = "sha256-DsITDNLsIgBIqN6sD5JHaFW0LToxVUTzWc7mE2L09IQ=";
    })
  ];

  baseConfigPath = "share/mautrix-googlechat/example-config.yaml";
  postInstall = ''
    rm $out/example-config.yaml
    install -D mautrix_googlechat/example-config.yaml $out/$baseConfigPath
  '';

  passthru.optional-dependencies = with python3.pkgs; {
    e2be = [
      python-olm
      pycryptodome
      unpaddedbase64
    ];
    metrics = [
      prometheus-client
    ];
    sqlite = [
      aiosqlite
    ];
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    commonmark
    yarl
    asyncpg
    ruamel-yaml
    commonmark
    python-magic
    protobuf
    mautrix
  ] ++ lib.optionals enableE2be passthru.optional-dependencies.e2be
  ++ lib.optionals enableMetrics passthru.optional-dependencies.metrics
  ++ lib.optionals enableSqlite passthru.optional-dependencies.sqlite;

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/googlechat";
    description = "Matrix-Google Chat puppeting bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arcnmx ];
    mainProgram = "mautrix-googlechat";
  };
}
