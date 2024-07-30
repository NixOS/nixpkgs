{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sphinx,
  glib,
  pcre,
  libmysqlclient,
  libressl,
  zlib,
  zstd,
  nix-update-script,
  testers,
  versionCheckHook,
  mydumper,
}:

stdenv.mkDerivation rec {
  pname = "mydumper";
  version = "0.16.3-6";

  src = fetchFromGitHub {
    owner = "mydumper";
    repo = "mydumper";
    rev = "refs/tags/v${version} ";
    hash = "sha256-iMhrwKRAorufmkkNU4h0BvLV6c3/cwYPdsGm41jTkZ4=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    sphinx
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  buildInputs = [
    glib
    pcre
    libmysqlclient
    libressl
    zlib
    zstd
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DMYSQL_INCLUDE_DIR=${lib.getDev libmysqlclient}/include/mysql"
    "-DWITH_ZSTD=ON"
  ];

  env.NIX_CFLAGS_COMPILE = (
    if stdenv.isDarwin then
      toString [
        "-Wno-error=deprecated-non-prototype"
        "-Wno-error=format"
      ]
    else
      "-Wno-unused-result"
  );

  postPatch = ''
    substituteInPlace CMakeLists.txt\
      --replace-fail "/etc" "$out/etc" \
  '';

  passthru.updateScript = nix-update-script { };

  # mydumper --version is checked in `versionCheckHook`
  passthru.tests = testers.testVersion {
    package = mydumper;
    command = "myloader --version";
    version = "myloader v${version}";
  };

  meta = with lib; {
    description = "High-performance MySQL backup tool";
    homepage = "https://github.com/mydumper/mydumper";
    changelog = "https://github.com/mydumper/mydumper/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [
      izorkin
      michaelglass
    ];
  };
}
