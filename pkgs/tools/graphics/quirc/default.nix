{ lib, stdenv, fetchFromGitHub, fetchpatch2, SDL_gfx, SDL, libjpeg, libpng
, opencv, pkg-config }:

stdenv.mkDerivation (finalAttrs: {
  pname = "quirc";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "dlbeer";
    repo = "quirc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zdq/YKL33jJXa10RqmQIl06rRYnrthWG+umT4dipft0=";
  };

  postPatch = ''
    # don't try to change ownership
    substituteInPlace Makefile \
      --replace-fail "-o root" "" \
      --replace-fail "-g root" ""
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL SDL_gfx libjpeg libpng opencv ];

  makeFlags = [ "PREFIX=$(out)" ];
  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL}/include/SDL -I${SDL_gfx}/include/SDL";

  patches = [
    (fetchpatch2 {
      url = "https://github.com/dlbeer/quirc/commit/2c350d8aaf37246e538a2c93b2cce8c78600d2fc.patch?full_index=1";
      hash = "sha256-ZTcy/EoOBoyOjtXjmT+J/JcbX8lxGKmbWer23lymbWo=";
    })
    (fetchpatch2 {
      url = "https://github.com/dlbeer/quirc/commit/257c6c94d99960819ecabf72199e5822f60a3bc5.patch?full_index=1";
      hash = "sha256-WLQK7vy34VmgJzppTnRjAcZoSGWVaXQSaGq9An8W0rw=";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Disable building of linux-only demos on darwin systems
    ./0001-Don-t-build-demos.patch
  ];

  preInstall = ''
    mkdir -p "$out"/{bin,lib,include}

    # install all binaries
    find -maxdepth 1 -type f -executable ! -name '*.so.*' ! -name '*.dylib' \
      | xargs cp -t "$out"/bin
  '';

  postInstall = ''
    # don't install static library
    rm $out/lib/libquirc.a
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Set absolute install name to avoid the need for DYLD_LIBRARY_PATH
    dylib=$out/lib/libquirc.${finalAttrs.version}.dylib
    ${stdenv.cc.targetPrefix}install_name_tool -id "$dylib" "$dylib"
  '';

  meta = {
    description = "Small QR code decoding library";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux ++ [ "x86_64-darwin" "aarch64-darwin" ];
  };
})
