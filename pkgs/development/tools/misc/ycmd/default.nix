{ stdenv, lib, fetchgit, cmake, llvmPackages, boost, python
, gocode ? null
, godef ? null
, rustracerd ? null
, fixDarwinDylibNames, Cocoa ? null
}:

stdenv.mkDerivation rec {
  name = "ycmd-${version}";
  version = "2018-07-24";

  src = fetchgit {
    url = "https://github.com/Valloric/ycmd.git";
    rev = "f8a8b04892b925efeee24298a957cc6d6a69ad06";
    sha256 = "1br2sh6bs0fg1axq2hq9f48fz8klkzydi1mf0j0jdsh3zjzkmxbn";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost llvmPackages.libclang ]
    ++ stdenv.lib.optional stdenv.isDarwin [ fixDarwinDylibNames Cocoa ];

  buildPhase = ''
    export EXTRA_CMAKE_ARGS=-DPATH_TO_LLVM_ROOT=${llvmPackages.clang-unwrapped}
    ${python.interpreter} build.py --system-libclang --clang-completer --system-boost
  '';

  configurePhase = ":";

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

    mkdir -p $out/lib/ycmd/third_party/{gocode,godef,racerd/target/release}

    for p in jedi waitress frozendict bottle parso python-future requests; do
      cp -r third_party/$p $out/lib/ycmd/third_party
    done

  '' + lib.optionalString (gocode != null) ''
    ln -s ${gocode}/bin/gocode $out/lib/ycmd/third_party/gocode
  '' + lib.optionalString (godef != null) ''
    ln -s ${godef}/bin/godef $out/lib/ycmd/third_party/godef
  '' + lib.optionalString (rustracerd != null) ''
    ln -s ${rustracerd}/bin/racerd $out/lib/ycmd/third_party/racerd/target/release
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
