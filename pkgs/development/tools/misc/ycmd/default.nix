{ stdenv, fetchgit, cmake, llvmPackages, boost, python, python2Packages }:

python2Packages.mkPythonDerivation rec {
  name = "ycmd-${version}";
  version = "2017-02-03";
  namePrefix = "";

  src = fetchgit {
    url = "git://github.com/Valloric/ycmd.git";
    rev = "ec7a154f8fe50c071ecd0ac6841de8a50ce92f5d";
    sha256 = "0rzxgqqqmmrv9r4k2ji074iprhw6sb0jkvh84wvi45yfyphsh0xi";
  };

  buildInputs = [ cmake boost ];

  buildPhase = ''
    export EXTRA_CMAKE_ARGS=-DPATH_TO_LLVM_ROOT=${llvmPackages.clang-unwrapped}
    ${python.interpreter} build.py --clang-completer --system-boost
  '';

  configurePhase = ":";

  installPhase = ''
    mkdir -p $out/lib/ycmd/third_party $out/bin
    cp -r ycmd/ third_party/ CORE_VERSION libclang.so.* ycm_core.so $out/lib/ycmd/
    ln -s $out/lib/ycmd/ycmd/__main__.py $out/bin/ycmd
  '';

  meta = with stdenv.lib; {
    description = "A code-completion and comprehension server";
    homepage = https://github.com/Valloric/ycmd;
    license = licenses.gpl3;
    maintainers = with maintainers; [ rasendubi ];
    platforms = platforms.all;
  };
}
