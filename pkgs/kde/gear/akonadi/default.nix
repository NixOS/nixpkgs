{
  lib,
  mkKdeDerivation,
  qttools,
  accounts-qt,
  kaccounts-integration,
  shared-mime-info,
  xz,
  mariadb,
  libpq,
  sqlite,
  backend ? "mysql",
}:

assert lib.assertOneOf "backend" backend [
  "mysql"
  "postgres"
  "sqlite"
];

let
  mariadb' = mariadb.overrideAttrs (old: {
    meta = old.meta // {
      # Akonadi runs MariaDB under the same user only allowing them socket access
      knownVulnerabilities = [ ];
    };
  });
in
mkKdeDerivation {
  pname = "akonadi";

  patches = [
    # Always regenerate MySQL config, as the store paths don't have accurate timestamps
    ./ignore-mysql-config-timestamp.patch
  ];

  extraCmakeFlags = [
    "-DDATABASE_BACKEND=${lib.toUpper backend}"
  ]
  ++ lib.optionals (backend == "mysql") [
    "-DMYSQLD_SCRIPTS_PATH=${lib.getBin mariadb'}/bin"
  ]
  ++ lib.optionals (backend == "postgres") [
    "-DPOSTGRES_PATH=${lib.getBin libpq}/bin"
  ];

  extraNativeBuildInputs = [
    qttools
    shared-mime-info
  ];

  extraBuildInputs = [
    kaccounts-integration
    accounts-qt
    xz
  ]
  ++ lib.optionals (backend == "mysql") [ mariadb' ]
  ++ lib.optionals (backend == "postgres") [ libpq ]
  ++ lib.optionals (backend == "sqlite") [ sqlite ];

  # Hardcoded as a QString, which is UTF-16 so Nix can't pick it up automatically

  postFixup = ''
    mkdir -p $out/nix-support
  ''
  + lib.optionalString (backend == "mysql") ''
    echo "${mariadb'}" > $out/nix-support/depends
  ''
  + lib.optionalString (backend == "postgres") ''
    echo "${libpq}" > $out/nix-support/depends
  '';
}
