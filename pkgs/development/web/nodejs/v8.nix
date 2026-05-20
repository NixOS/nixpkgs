# Derivation for Node.js CI (not officially supported for regular applications)
{
  stdenv,
  lib,
  icu,
  ninja,
  python,
  symlinkJoin,
  temporal_capi,
  testers,
  unixtools,
  validatePkgConfig,
  writeTextFile,

  src,
  version,
  configureScript,
  darwin-cctools-only-libtool,
}:

let
  sharedLibsToMock =
    let
      sharedLibsToMock = {
        zlib = [ "zlib" ];
        http-parser = [ "libllhttp" ];
        libuv = [ "libuv" ];
        ada = [ "ada" ];
        simdjson = [ "simdjson" ];
        brotli = [
          "libbrotlidec"
          "libbrotlienc"
        ];
        cares = [ "libcares" ];
        gtest = [ "gtest" ];
        hdr-histogram = [ "hdr_histogram" ];
        merve = [ "merve" ];
        nbytes = [ "nbytes" ];
        nghttp2 = [ "libnghttp2" ];
        nghttp3 = [ "libnghttp3" ];
        ngtcp2 = [ "libngtcp2" ];
        uvwasi = [ "uvwasi" ];
        zstd = [ "libzstd" ];
      };
    in
    symlinkJoin (finalAttrs: {
      pname = "non-v8-deps-mock";
      version = "0.0.0-mock";

      nativeBuildInputs = [ validatePkgConfig ];

      paths = lib.concatMap (
        sharedLibName:
        (builtins.map (
          pkgName:
          writeTextFile {
            name = "mock-${pkgName}.pc";
            destination = "/lib/pkgconfig/${pkgName}.pc";
            text = ''
              Name: ${pkgName}
              Description: Mock package for ${sharedLibName}
              Version: ${finalAttrs.version}
              Libs:
              Cflags:
            '';
          }
        ) sharedLibsToMock.${sharedLibName})
      ) (builtins.attrNames sharedLibsToMock);
      passthru = {
        configureFlags = [
          "--without-lief"
          "--without-sqlite"
          "--without-ffi"
          "--without-ssl"
        ]
        ++ (lib.concatMap (sharedLibName: [
          "--shared-${sharedLibName}"
          "--shared-${sharedLibName}-libname="
        ]) (builtins.attrNames sharedLibsToMock));

        tests.pkg-config = testers.hasPkgConfigModules {
          package = finalAttrs.finalPackage;
        };
      };

      meta = {
        description = "Mock of Node.js dependencies that are not needed for building V8";
        license = lib.licenses.mit;
        pkgConfigModules = lib.concatMap (x: x) (builtins.attrValues sharedLibsToMock);
      };
    });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "v8";

  inherit
    version
    src
    configureScript
    ;

  buildInputs = [
    icu
    sharedLibsToMock
    temporal_capi
  ];

  configureFlags = sharedLibsToMock.configureFlags ++ [
    "--ninja"
    "--with-intl=system-icu"
    "--v8-enable-temporal-support"
    "--shared-temporal_capi"
  ];
  nativeBuildInputs = [
    ninja
    python
    validatePkgConfig
  ]
  ++ lib.optionals stdenv.buildPlatform.isDarwin [
    # gyp checks `sysctl -n hw.memsize` if `sys.platform == "darwin"`.
    unixtools.sysctl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # For gyp-mac-tool if `flavor == "mac"`.
    darwin-cctools-only-libtool
  ];

  buildPhase = ''
    runHook preBuild
    ninja -v -C out/Release v8_snapshot v8_libplatform
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        # Darwin is excluded from creating thin archive in tools/gyp/pylib/gyp/generator/ninja.py:2488
        "install -Dm644 out/Release/lib* -t $out/lib"
      else
        # On other platforms, we need to create non-thin archive.
        ''
          mkdir -p $out/lib
          for a in out/Release/obj/tools/v8_gypfiles/lib*; do
            base=$(basename "$a")
            dir=$(dirname "$a")

            (
              cd "$dir"
              "$AR" rc "$out/lib/$base" $("$AR" t "$base")
            )

            "$RANLIB" "$out/lib/$base"
          done
        ''
    }

    install -Dm644 deps/v8/third_party/simdutf/simdutf.h -t $out/include
    find deps/v8/include -name '*.h' -print0 | while read -r -d "" file; do
      install -Dm644 "$file" -T "$out/include/''${file#deps/v8/include/}"
    done
    find deps/v8/third_party/abseil-cpp/absl -name '*.h' -print0 | while read -r -d "" file; do
      install -Dm644 "$file" -T "$out/include/''${file#deps/v8/third_party/abseil-cpp/}"
    done

    mkdir -p $out/lib/pkgconfig
    cat -> $out/lib/pkgconfig/v8.pc << EOF
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=\''${exec_prefix}/lib
    includedir=\''${prefix}/include

    Name: v8
    Description: V8 JavaScript Engine build for Node.js CI
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} $(for f in $out/lib/lib*.a; do
      b=$(basename "$f" .a)
      printf " -l%s" "''${b#lib}"
    done) -lstdc++
    Cflags: -I\''${includedir}
    EOF

    runHook postInstall
  '';
})
