{ stdenv, fetchgit, cmake, python, llvmPackages, boost, pythonPackages, buildPythonApplication, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "ycmd-2016-01-12";

  src = fetchgit {
    url = "git://github.com/Valloric/ycmd.git";
    rev = "f982f6251c5ff85e3abe6e862aad8bcd19e85ece";
    sha256 = "1qp3ip6ab34610rfy0x85xsjg7blfkiy025vskwk9zw6gqglf3b3";
  };

  buildInputs = [ python cmake llvmPackages.clang boost makeWrapper ];

  propagatedBuildInputs = with pythonPackages; [ waitress frozendict bottle ];

  buildPhase = ''
    python build.py --clang-completer --system-libclang --system-boost
  '';

  configurePhase = ":";

  installPhase = with pythonPackages; ''
    mkdir -p $out/lib/ycmd/third_party $out/bin
    cp -r ycmd/ CORE_VERSION libclang.so.* ycm_client_support.so ycm_core.so $out/lib/ycmd/
    wrapProgram $out/lib/ycmd/ycmd/__main__.py \
      --prefix PYTHONPATH : "$(toPythonPath ${waitress}):$(toPythonPath ${frozendict}):$(toPythonPath ${bottle})"
    ln -s $out/lib/ycmd/ycmd/__main__.py $out/bin/ycmd
  '';

  meta = {
    description = "A code-completion and comprehension server";
    homepage = "https://github.com/Valloric/ycmd";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
