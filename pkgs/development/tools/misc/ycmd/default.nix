{ stdenv, lib, fetchgit, cmake, llvmPackages, boost, python2Packages
, gocode ? null
, godef ? null
, rustracerd ? null
}:

let
  inherit (python2Packages) python mkPythonDerivation waitress frozendict bottle future argparse requests;
  pathFixup =  "import os; os.environ['PATH'] = ('{0}:{1}' if os.getenv('PATH', '') != '' else '{1}').format('$program_PATH', os.getenv('PATH', ''))";
in mkPythonDerivation rec {
  name = "ycmd-${version}";
  version = "2017-02-03";
  namePrefix = "";

  src = fetchgit {
    url = "git://github.com/Valloric/ycmd.git";
    rev = "ec7a154f8fe50c071ecd0ac6841de8a50ce92f5d";
    sha256 = "0rzxgqqqmmrv9r4k2ji074iprhw6sb0jkvh84wvi45yfyphsh0xi";
  };

  buildInputs = [ cmake boost ];

  propagatedBuildInputs = [ waitress frozendict bottle future argparse requests ];

  buildPhase = ''
    export EXTRA_CMAKE_ARGS=-DPATH_TO_LLVM_ROOT=${llvmPackages.clang-unwrapped}
    ${python.interpreter} build.py --clang-completer --system-boost
  '';

  configurePhase = ":";

  # remove the tests
  #
  # make __main__.py executable so mkPythonDerivation's postFixup modifies the
  # executable (e.g. fixup PYTHONPATH)
  #
  # add a shebang (will be rewritten by postFixup)
  #
  # symlink completion backends where ycmd expects them
  installPhase = ''
    rm -rf ycmd/tests

    chmod +x ycmd/__main__.py
    sed -i "1i #!/usr/bin/env python\
    " ycmd/__main__.py

    mkdir -p $out/lib/ycmd
    cp -r ycmd/ CORE_VERSION libclang.so.* ycm_core.so $out/lib/ycmd/

    mkdir -p $out/bin
    ln -s $out/lib/ycmd/ycmd/__main__.py $out/bin/ycmd

    mkdir -p $out/lib/ycmd/third_party/{gocode,godef,racerd/target/release}
    cp -r third_party/JediHTTP/ $out/lib/ycmd/third_party
  '' + lib.optionalString (gocode != null) ''
    ln -s ${gocode}/bin/gocode $out/lib/ycmd/third_party/gocode
  '' + lib.optionalString (godef != null) ''
    ln -s ${godef}/bin/godef $out/lib/ycmd/third_party/godef
  '' + lib.optionalString (rustracerd != null) ''
    ln -s ${rustracerd}/bin/racerd $out/lib/ycmd/third_party/racerd/target/release
  '';

  # mkPythonDerivation will attempt to create a wrapper script (written in bash)
  # but we don't want the indirection as several editor plugins want to invoke
  # ycmd as `python path/to/ycmd`, which will obviously fail in that case -
  # so we move the original file back over
  #
  # also fixup the argv[0] and replace __file__ with the corresponding path so
  # python won't be thrown off by argv[0]
  postFixup = ''
    mv $out/lib/ycmd/ycmd/{.__main__.py-wrapped,__main__.py}

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
    maintainers = with maintainers; [ rasendubi ];
    platforms = platforms.all;
  };
}
