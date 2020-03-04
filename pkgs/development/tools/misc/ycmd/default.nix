{ stdenv, lib, fetchgit, cmake, llvmPackages, boost, python
, gocode ? null
, godef ? null
, gotools ? null
, rustracerd ? null
, fixDarwinDylibNames, Cocoa ? null
}:

stdenv.mkDerivation {
  pname = "ycmd";
  version = "2020-02-22";
  disabled = !python.isPy3k;

  src = fetchgit {
    url = "https://github.com/Valloric/ycmd.git";
    rev = "9a6b86e3a156066335b678c328f226229746bae5";
    sha256 = "1c5axdngxaxj5vc6lr8sxb99mr5adsm1dnjckaxc23kq78pc8cn7";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost llvmPackages.libclang ]
    ++ stdenv.lib.optional stdenv.isDarwin [ fixDarwinDylibNames Cocoa ];

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

  '' + lib.optionalString (gocode != null) ''
    TARGET=$out/lib/ycmd/third_party/gocode
    mkdir -p $TARGET
    ln -sf ${gocode}/bin/gocode $TARGET
  '' + lib.optionalString (godef != null) ''
    TARGET=$out/lib/ycmd/third_party/godef
    mkdir -p $TARGET
    ln -sf ${godef}/bin/godef $TARGET
  '' + lib.optionalString (gotools != null) ''
    TARGET=$out/lib/ycmd/third_party/go/src/golang.org/x/tools/cmd/gopls
    mkdir -p $TARGET
    ln -sf ${gotools}/bin/gopls $TARGET
  '' + lib.optionalString (rustracerd != null) ''
    TARGET=$out/lib/ycmd/third_party/racerd/target/release
    mkdir -p $TARGET
    ln -sf ${rustracerd}/bin/racerd $TARGET
  '';

  # fixup the argv[0] and replace __file__ with the corresponding path so
  # python won't be thrown off by argv[0]
  postFixup = ''
    substituteInPlace $out/lib/ycmd/ycmd/__main__.py \
      --replace $out/lib/ycmd/ycmd/__main__.py \
                $out/bin/ycmd \
      --replace __file__ \
                "'$out/lib/ycmd/ycmd/__main__.py'"
  '';

  meta = with stdenv.lib; {
    description = "A code-completion and comprehension server";
    homepage = https://github.com/Valloric/ycmd;
    license = licenses.gpl3;
    maintainers = with maintainers; [ rasendubi cstrahan lnl7 ];
    platforms = platforms.all;
  };
}
