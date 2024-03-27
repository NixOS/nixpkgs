{ stdenv
, lib
, fetchFromGitHub
, cmake
, ninja
, python
, withGodef ? true
, godef
, withGotools ? true
, gotools
, withTypescript ? true
, typescript
, abseil-cpp
, boost
, llvmPackages
, fixDarwinDylibNames
, Cocoa
}:

stdenv.mkDerivation {
  pname = "ycmd";
  version = "unstable-2023-11-06";
  disabled = !python.isPy3k;

  # required for third_party directory creation
  src = fetchFromGitHub {
    owner = "ycm-core";
    repo = "ycmd";
    rev = "0607eed2bc211f88f82657b7781f4fe66579855b";
    hash = "sha256-SzEcMQ4lX7NL2/g9tuhA6CaZ8pX/DGs7Fla/gr+RcOU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ninja ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = with python.pkgs; with llvmPackages; [ abseil-cpp boost libllvm.all libclang.all ]
    ++ [ jedi jedi-language-server pybind11 ]
    ++ lib.optional stdenv.isDarwin Cocoa;

  buildPhase = ''
    export EXTRA_CMAKE_ARGS="-DPATH_TO_LLVM_ROOT=${llvmPackages.libllvm} -DUSE_SYSTEM_ABSEIL=true"
    ${python.pythonOnBuildForHost.interpreter} build.py --system-libclang --clang-completer --ninja
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
    find third_party -type d -name "test" -exec rm -rf {} +

    chmod +x ycmd/__main__.py
    sed -i "1i #!${python.interpreter}\
    " ycmd/__main__.py

    mkdir -p $out/lib/ycmd
    cp -r ycmd/ CORE_VERSION *.so* *.dylib* $out/lib/ycmd/

    mkdir -p $out/bin
    ln -s $out/lib/ycmd/ycmd/__main__.py $out/bin/ycmd

    # Copy everything: the structure of third_party has been known to change.
    # When linking our own libraries below, do so with '-f'
    # to clobber anything we may have copied here.
    mkdir -p $out/lib/ycmd/third_party
    cp -r third_party/* $out/lib/ycmd/third_party/

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
    ln -sf ${typescript} $TARGET
  '';

  # fixup the argv[0] and replace __file__ with the corresponding path so
  # python won't be thrown off by argv[0]
  postFixup = ''
    substituteInPlace $out/lib/ycmd/ycmd/__main__.py \
      --replace __file__ "'$out/lib/ycmd/ycmd/__main__.py'"
  '';

  meta = with lib; {
    description = "A code-completion and comprehension server";
    mainProgram = "ycmd";
    homepage = "https://github.com/ycm-core/ycmd";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rasendubi lnl7 siriobalmelli ];
    platforms = platforms.all;
  };
}
