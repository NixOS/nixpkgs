{ stdenv, fetchgit, cmake, python, llvmPackages, boost, pythonPackages, buildPythonApplication, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "ycmd-2016-01-12";

  src = fetchgit {
    url = "git://github.com/Valloric/ycmd.git";
    rev = "f982f6251c5ff85e3abe6e862aad8bcd19e85ece";
    sha256 = "1g0hivv3wla7z5dgnkcn3ny38p089pjfj36nx6k29zmprgmjinyr";
  };

  buildInputs = [ python cmake boost makeWrapper ];

  propagatedBuildInputs = with pythonPackages; [ waitress frozendict bottle ];

  buildPhase = ''
    export EXTRA_CMAKE_ARGS=-DPATH_TO_LLVM_ROOT=${llvmPackages.clang-unwrapped}
    python build.py --clang-completer --system-boost
  '';

  configurePhase = ":";

  installPhase = with pythonPackages; ''
    mkdir -p $out/lib/ycmd/third_party $out/bin
    cp -r ycmd/ CORE_VERSION libclang.so.* ycm_client_support.so ycm_core.so $out/lib/ycmd/
    wrapProgram $out/lib/ycmd/ycmd/__main__.py \
      --prefix PYTHONPATH : "$(toPythonPath ${waitress}):$(toPythonPath ${frozendict}):$(toPythonPath ${bottle})"
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
