{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildPackages,
  pkg-config,
  meson,
  ninja,
  libusb-compat-0_1,
  readline,
  libewf,
  perl,
  zlib,
  openssl,
  libuv,
  file,
  libzip,
  xxHash,
  gtk2,
  vte,
  gtkdialog,
  python3,
  ruby,
  lua,
  lz4,
  capstone,
  useX11 ? false,
  rubyBindings ? false,
  luaBindings ? false,
}:

let
  # FIXME: Compare revision with
  # https://github.com/radareorg/radare2/blob/master/libr/arch/p/arm/v35/Makefile#L26-L27
  arm64 = fetchFromGitHub {
    owner = "radareorg";
    repo = "vector35-arch-arm64";
    rev = "55d73c6bbb94448a5c615933179e73ac618cf876";
    hash = "sha256-pZxxp5xDg8mgkGEx7LaBSoKxNPyggFYA4um9YaO20LU=";
  };
  armv7 = fetchFromGitHub {
    owner = "radareorg";
    repo = "vector35-arch-armv7";
    rev = "f270a6cc99644cb8e76055b6fa632b25abd26024";
    hash = "sha256-YhfgJ7M8ys53jh1clOzj0I2yfJshXQm5zP0L9kMYsmk=";
  };
in
stdenv.mkDerivation rec {
  pname = "radare2";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "radare";
    repo = "radare2";
    rev = "refs/tags/${version}";
    hash = "sha256-h2IYOGr+yCgCJR1gB4jibcUt1A+8IuNVoTUcJ83lKHw=";
  };

  preBuild = ''
    pushd ../libr/arch/p/arm/v35
    cp -r ${arm64} arch-arm64
    chmod -R +w arch-arm64

    cp -r ${armv7} arch-armv7
    chmod -R +w arch-armv7
    popd
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath $out/lib $out/lib/libr_io.${version}.dylib
  '';

  mesonFlags = [
    "-Duse_sys_capstone=true"
    "-Duse_sys_magic=true"
    "-Duse_sys_zip=true"
    "-Duse_sys_xxhash=true"
    "-Duse_sys_lz4=true"
    "-Dr2_gittap=${version}"
  ];

  # TODO: remove when upstream fixes the issue
  # https://github.com/radareorg/radare2/issues/22793
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.isDarwin [
      "-DTHREAD_CONVERT_THREAD_STATE_TO_SELF=1"
    ]
  );

  enableParallelBuilding = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];
  buildInputs =
    [
      capstone
      file
      readline
      libusb-compat-0_1
      libewf
      perl
      zlib
      openssl
      libuv
      lz4
    ]
    ++ lib.optionals useX11 [
      gtkdialog
      vte
      gtk2
    ]
    ++ lib.optionals rubyBindings [ ruby ]
    ++ lib.optionals luaBindings [ lua ];

  propagatedBuildInputs = [
    # radare2 exposes r_lib which depends on these libraries
    file # for its list of magic numbers (`libmagic`)
    libzip
    xxHash
  ];

  meta = with lib; {
    description = "UNIX-like reverse engineering framework and command-line tools";
    homepage = "https://radare.org";
    changelog = "https://github.com/radareorg/radare2/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      azahi
      raskin
      makefu
      mic92
      arkivm
    ];
    platforms = platforms.unix;
  };
}
