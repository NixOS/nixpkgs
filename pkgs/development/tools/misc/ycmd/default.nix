{ stdenv, lib, fetchgit, cmake, llvmPackages, boost, python
, gocode ? null
, godef ? null
, rustracerd ? null
, Cocoa ? null
}:

stdenv.mkDerivation rec {
  name = "ycmd-${version}";
  version = "2017-02-03";

  src = fetchgit {
    url = "git://github.com/Valloric/ycmd.git";
    rev = "ec7a154f8fe50c071ecd0ac6841de8a50ce92f5d";
    sha256 = "0rzxgqqqmmrv9r4k2ji074iprhw6sb0jkvh84wvi45yfyphsh0xi";
  };

  buildInputs = [ cmake boost ]  ++ stdenv.lib.optional stdenv.isDarwin Cocoa;

  buildPhase = ''
    export EXTRA_CMAKE_ARGS=-DPATH_TO_LLVM_ROOT=${llvmPackages.clang-unwrapped}
    ${python.interpreter} build.py --clang-completer --system-boost
  '';

  patches = [ ./2-ycm-cmake.patch ];

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
    cp -r ycmd/ CORE_VERSION libclang.so.* ycm_core.so $out/lib/ycmd/

    mkdir -p $out/bin
    ln -s $out/lib/ycmd/ycmd/__main__.py $out/bin/ycmd

    mkdir -p $out/lib/ycmd/third_party/{gocode,godef,racerd/target/release}

    cp -r third_party/JediHTTP $out/lib/ycmd/third_party
    for p in waitress frozendict bottle python-future argparse requests; do
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
    maintainers = with maintainers; [ rasendubi cstrahan ];
    platforms = platforms.all;
  };
}
