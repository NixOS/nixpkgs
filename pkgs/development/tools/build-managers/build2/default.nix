{ stdenv, lib
, build2
, fetchurl
, fetchpatch
, fixDarwinDylibNames
, libbutl
, libpkgconf
, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? !enableShared
}:
let
  configSharedStatic = enableShared: enableStatic:
    if enableShared && enableStatic then "both"
    else if enableShared then "shared"
    else if enableStatic then "static"
    else throw "neither shared nor static libraries requested";
in
stdenv.mkDerivation rec {
  pname = "build2";
  version = "0.13.0";

  outputs = [ "out" "dev" "doc" "man" ];

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "https://pkg.cppget.org/1/alpha/build2/build2-${version}.tar.gz";
    sha256 = "aff53a87c23534e0232b5cf746e0be4b2aaa840c3de4e668b98e382a3973c45e";
  };

  patches = [
    # Remove any build/host config entries which refer to nix store paths
    ./remove-config-store-paths.patch
    # Pick up sysdirs from NIX_LDFLAGS
    ./nix-ldflags-sysdirs.patch
    # Fix stray '-l' linker flags in pkg-config files (remove in next release)
    (fetchpatch {
      url = "https://github.com/build2/build2/commit/d51892e33a0fe69e743e02d9620312133a7ac61d.patch";
      sha256 = "0xzm084bxnfi8lqng0cwxvz8ylbfzk0didbr2wf385gssv4fva81";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [
    build2
  ];
  disallowedReferences = [
    build2
    libbutl.dev
    libpkgconf.dev
  ];
  buildInputs = [
    libbutl
    libpkgconf
  ];

  # Build2 uses @rpath on darwin
  # https://github.com/build2/build2/issues/166
  # N.B. this only adjusts the install_name after all libraries are installed;
  # packages containing multiple interdependent libraries may have
  # LC_LOAD_DYLIB entries containing @rpath, requiring manual fixup
  propagatedBuildInputs = lib.optionals stdenv.targetPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  postPatch = ''
    patchShebangs --build tests/bash/testscript
  '';

  build2ConfigureFlags = [
    "config.bin.lib=${configSharedStatic enableShared enableStatic}"
    "config.cc.poptions+=-I${lib.getDev libpkgconf}/include/pkgconf"
  ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath "''${!outputLib}/lib" "''${!outputBin}/bin/b"
  '';

  passthru = {
    bootstrap = build2;
    inherit configSharedStatic;
  };

  meta = with lib; {
    homepage = "https://www.build2.org/";
    description = "build2 build system";
    license = licenses.mit;
    longDescription = ''
      build2 is an open source (MIT), cross-platform build toolchain
      that aims to approximate Rust Cargo's convenience for developing
      and packaging C/C++ projects while providing more depth and
      flexibility, especially in the build system.

      build2 is a hierarchy of tools consisting of a general-purpose
      build system, package manager (for package consumption), and
      project manager (for project development). It is primarily aimed
      at C/C++ projects as well as mixed-language projects involving
      one of these languages (see bash and rust modules, for example).
    '';
    changelog = "https://git.build2.org/cgit/build2/tree/NEWS";
    platforms = platforms.all;
    maintainers = with maintainers; [ hiro98 r-burns ];
  };
}
