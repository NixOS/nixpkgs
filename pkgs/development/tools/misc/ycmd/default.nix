{ stdenv, lib, fetchFromGitHub, cmake, llvmPackages, boost, python
, withGocode ? true, gocode
, withGodef ? true, godef
, withGotools? true, gotools
, withTypescript ? true, nodePackages
, fixDarwinDylibNames, Cocoa
}:

stdenv.mkDerivation {
  pname = "ycmd";
  version = "unstable-2020-02-22";
  disabled = !python.isPy3k;

  # required for third_party directory creation
  src = fetchFromGitHub {
    owner = "Valloric";
    repo = "ycmd";
    rev = "9a6b86e3a156066335b678c328f226229746bae5";
    sha256 = "sha256-xzLELjp4DsG6mkzaFqpuquSa0uoaZWrYLrKr/mzrqrA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = [ boost llvmPackages.libclang ]
    ++ lib.optional stdenv.isDarwin Cocoa;

  buildPhase = ''
    export EXTRA_CMAKE_ARGS=-DPATH_TO_LLVM_ROOT=${llvmPackages.clang-unwrapped}
    ${python.interpreter} build.py --system-libclang --clang-completer --system-boost
  '';

  dontConfigure = true;

  # remove the tests
  #
  # make __main__.py executable and add shebang
  #
  # copy over third-party libs
  # note: if we switch to using our packaged libs, we'll need to symlink them
  # into the same spots, as YouCompleteMe (the vim plugin) expects those paths
  # to be available
  #
  # symlink completion backends where ycmd expects them
  installPhase = ''
    rm -rf ycmd/tests

    chmod +x ycmd/__main__.py
    sed -i "1i #!${python.interpreter}\
    " ycmd/__main__.py

    mkdir -p $out/lib/ycmd
    cp -r ycmd/ CORE_VERSION libclang.so.* libclang.dylib* ycm_core.so $out/lib/ycmd/

    mkdir -p $out/bin
    ln -s $out/lib/ycmd/ycmd/__main__.py $out/bin/ycmd

    # Copy everything: the structure of third_party has been known to change.
    # When linking our own libraries below, do so with '-f'
    # to clobber anything we may have copied here.
    mkdir -p $out/lib/ycmd/third_party
    cp -r third_party/* $out/lib/ycmd/third_party/

  '' + lib.optionalString withGocode ''
    TARGET=$out/lib/ycmd/third_party/gocode
    mkdir -p $TARGET
    ln -sf ${gocode}/bin/gocode $TARGET
  '' + lib.optionalString withGodef ''
    TARGET=$out/lib/ycmd/third_party/godef
    mkdir -p $TARGET
    ln -sf ${godef}/bin/godef $TARGET
  '' + lib.optionalString withGotools ''
    TARGET=$out/lib/ycmd/third_party/go/src/golang.org/x/tools/cmd/gopls
    mkdir -p $TARGET
    ln -sf ${gotools}/bin/gopls $TARGET
  '' + lib.optionalString withTypescript ''
    TARGET=$out/lib/ycmd/third_party/tsserver
    ln -sf ${nodePackages.typescript} $TARGET
  '';

  # fixup the argv[0] and replace __file__ with the corresponding path so
  # python won't be thrown off by argv[0]
  postFixup = ''
    substituteInPlace $out/lib/ycmd/ycmd/__main__.py \
      --replace $out/lib/ycmd/ycmd/__main__.py $out/bin/ycmd \
      --replace __file__ "'$out/lib/ycmd/ycmd/__main__.py'"
  '';

  meta = with lib; {
    description = "A code-completion and comprehension server";
    homepage = "https://github.com/Valloric/ycmd";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rasendubi cstrahan lnl7 ];
    platforms = platforms.all;
  };
}
