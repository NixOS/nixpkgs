{ fetchFromGitHub, fetchpatch
, lib
, python3
, protobuf3_20
, enableE2be ? true, enableMetrics ? true, enableSqlite ? true
}: python3.pkgs.buildPythonApplication rec {
  pname = "mautrix-googlechat";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "googlechat";
    rev = "v${version}";
    sha256 = "sha256-UVWYT0HTOUEkBG0n6KNhCSSO/2PAF1rIvCaw478z+q0=";
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

  doCheck = false;

  postPatch = ''
    sed -i requirements.txt \
      -e 's/asyncpg>=.*/asyncpg/'
  '';

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
    metrics = [ prometheus-client ];
    sqlite = [ aiosqlite ];
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    yarl
    asyncpg
    ruamel-yaml
    CommonMark
    python-magic
    (protobuf.override {
      protobuf = protobuf3_20;
    })
    mautrix
  ] ++ lib.optionals enableE2be passthru.optional-dependencies.e2be
  ++ lib.optionals enableMetrics passthru.optional-dependencies.metrics
  ++ lib.optionals enableSqlite passthru.optional-dependencies.sqlite;

  meta = with lib; {
    homepage = "https://github.com/mautrix/googlechat";
    description = "A Matrix-Google Chat puppeting bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arcnmx ];
  };
}
