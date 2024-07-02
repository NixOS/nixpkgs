{ lib
, stdenv
, darwin
, fetchurl, zstd
, makeWrapper
, pkg-config
, rustPlatform
, runCommand
, cargo
, fontconfig
, gentium
, harfbuzz
, icu
, jq
, libiconv
, lua
, makeFontsConf
, poppler_utils
, rustc
, sile
}:

let
  luaEnv = lua.withPackages(ps: with ps; [
    cassowary
    cldr
    fluent
    linenoise
    loadkit
    lpeg
    lua-zlib
    lua_cliargs
    luaepnf
    luaexpat
    luafilesystem
    luarepl
    luasec
    luasocket
    luautf8
    penlight
    vstruct
  ] ++ lib.optionals (lib.versionOlder lua.luaversion "5.2") [
    bit32
  ] ++ lib.optionals (lib.versionOlder lua.luaversion "5.3") [
    compat53
  ]);

  in stdenv.mkDerivation (finalAttrs: {
  pname = "sile";
  version = "0.15.4";

  src = fetchurl {
    url = "https://github.com/sile-typesetter/sile/releases/download/v${finalAttrs.version}/sile-${finalAttrs.version}.tar.zst";
    sha256 = "sha256-Ndg3s4LvSTNIm66haSZLlBQ9oVOOcc28ZAwvdcOeI1g=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.cargoSetupHook
    jq
    cargo
    rustc
    zstd
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    dontConfigure = true;
    hash = "sha256-FD2otvk92/99AT3BEmfbID8j8MFIicshcocPZalPTHQ=";
  };

  buildInputs = [
    luaEnv
    harfbuzz
    icu
    fontconfig
    libiconv
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  configureFlags = [
    # Build SILE's internal VM against headers from the Nix supplied Lua
    "--with-system-lua-sources"
    # Nix will supply all the Lua dependencies, so stop the build system from
    # bundling vendored copies of them.
    "--with-system-luarocks"
    # The automake check target uses pdfinfo to confirm the output of a test
    # run, and uses autotools to discover it. Nix builds have to that test
    # because it is run from the source directory with a binary already built
    # with system paths, so it can't be checked under Nix until after install.
    # After install the Makefile isn't available of course, so we have our own
    # copy of it with a hard coded path to `pdfinfo`. By specifying some binary
    # here we skip the configure time test for `pdfinfo`, by using `false` we
    # make sure that if it is expected during build time we would fail to build
    # since we only provide it at test time.
    "PDFINFO=false"
    # We're using Cargo to build a shared library skipping some libtool bits
    # that Nix mistakenly assumes are relevant and thinks it needs to cleanup.
    "RANLIB=:"
  ] ++ lib.optionals (!lua.pkgs.isLuaJIT) [
    "--without-luajit"
  ];

  postPatch = ''
    patchShebangs build-aux/*.sh build-aux/git-version-gen
  '';

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework AppKit";

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [
      gentium
    ];
  };

  enableParallelBuilding = true;

  preBuild = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace libtexpdf/dpxutil.c \
      --replace "ASSERT(ht && ht->table && iter);" "ASSERT(ht && iter);"
  '';

  passthru = {
    # So it will be easier to inspect this environment, in comparison to others
    inherit luaEnv;
    # Copied from Makefile.am
    tests.test = lib.optionalAttrs (!(stdenv.isDarwin && stdenv.isAarch64)) (
      runCommand "sile-test" {
          nativeBuildInputs = [ poppler_utils sile ];
          inherit (finalAttrs) FONTCONFIG_FILE;
        } ''
        output=$(mktemp -t selfcheck-XXXXXX.pdf)
        echo "<sile>foo</sile>" | sile -o $output -
        pdfinfo $output | grep "SILE v${finalAttrs.version}" > $out
      '');
  };

  # remove forbidden references to $TMPDIR
  preFixup = lib.optionalString stdenv.isLinux ''
    for f in "$out"/bin/*; do
      if isELF "$f"; then
        patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$f"
      fi
    done
  '';

  outputs = [ "out" "doc" "man" "dev" ];

  meta = with lib; {
    mainProgram = "sile";
    description = "Typesetting system";
    longDescription = ''
      SILE is a typesetting system; its job is to produce beautiful
      printed documents. Conceptually, SILE is similar to TeX—from
      which it borrows some concepts and even syntax and
      algorithms—but the similarities end there. Rather than being a
      derivative of the TeX family SILE is a new typesetting and
      layout engine written from the ground up using modern
      technologies and borrowing some ideas from graphical systems
      such as InDesign.
    '';
    homepage = "https://sile-typesetter.org";
    changelog = "https://github.com/sile-typesetter/sile/raw/v${finalAttrs.version}/CHANGELOG.md";
    platforms = platforms.unix;
    maintainers = with maintainers; [ doronbehar alerque ];
    license = licenses.mit;
  };
})
