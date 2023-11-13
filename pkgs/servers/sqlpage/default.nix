{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, sqlite
, zstd
, stdenv
, darwin
, fetchurl
}:

let
  apexcharts = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/apexcharts@3.41.0/dist/apexcharts.min.js";
    sha256 = "sha256-JvfrbG0Jkj1XzwMu28wweq4DTzHgRAQHmC5f0stdU5Q=";
  };
  tablerCss = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta19/dist/css/tabler.min.css";
    sha256 = "sha256-vvqPe3OoUsri+/z6/s3a9LZ/u0tM07VNmVWopaXS3Uk=";
  };
  tablerVendorsCss = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta19/dist/css/tabler-vendors.min.css";
    sha256 = "sha256-Pxz9YzwGJIUlHDNZMU9h7Lz/7qA/t0ehlRfC1P8wzxE=";
  };
  tablerJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta19/dist/js/tabler.min.js";
    sha256 = "sha256-xnY4FSLoAEy0TVjo/xv488tAXOrI+hvXGvEVVQdMDk8=";
  };
  listJsFixed = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/list.js-fixed@2.3.2/dist/list.min.js";
    sha256 = "sha256-mwE8YX5fgYlI9M7zCNDlPxT7pb7NJPkOyo1Y+4At85s=";
  };
  tablerIcons = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@tabler/icons@2.30.0/tabler-sprite.svg";
    sha256 = "sha256-xRHWlHNQraZpiRlgVswkfgN1qMrjQOtRYAq1N/DccgQ=";
  };
in

rustPlatform.buildRustPackage rec {
  pname = "sqlpage";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "SQLpage";
    rev = "v${version}";
    hash = "sha256-6KJ3phhOf10S0EMdolUw3sdXm1G7yuF+Ii/AjdgBE+s=";
  };

  postPatch = ''
    substituteInPlace sqlpage/apexcharts.js \
      --replace '/* !include https://cdn.jsdelivr.net/npm/apexcharts@3.41.0/dist/apexcharts.min.js */' \
      "$(cat ${apexcharts})"
    substituteInPlace sqlpage/sqlpage.css \
      --replace '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta19/dist/css/tabler.min.css */' \
      "$(cat ${tablerCss})"
    substituteInPlace sqlpage/sqlpage.css \
      --replace '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta19/dist/css/tabler-vendors.min.css */' \
      "$(cat ${tablerVendorsCss})"
    substituteInPlace sqlpage/sqlpage.js \
      --replace '/* !include https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta19/dist/js/tabler.min.js */' \
      "$(cat ${tablerJs})"
    substituteInPlace sqlpage/sqlpage.js \
      --replace '/* !include https://cdn.jsdelivr.net/npm/list.js-fixed@2.3.2/dist/list.min.js */' \
      "$(cat ${listJsFixed})"
    substituteInPlace sqlpage/tabler-icons.svg \
      --replace '/* !include https://cdn.jsdelivr.net/npm/@tabler/icons@2.30.0/tabler-sprite.svg */' \
      "$(cat ${tablerIcons})"
  '';

  cargoHash = "sha256-kJzBvZSh6jkSJ4um+KYp7fKklDPlvOgz5NQb7j99brw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      sqlite
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "SQL-only webapp builder, empowering data analysts to build websites and applications quickly";
    homepage = "https://github.com/lovasoa/SQLpage";
    changelog = "https://github.com/lovasoa/SQLpage/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
