args:
args.stdenv.mkDerivation {
  name = "pydb-1.26";

  src = args.fetchurl {
    url =  "mirror://sourceforge.net/sourceforge/bashdb/pydb-1.26.tar.bz2";
    sha256 = "1wlkz1hd5d4gkzhkjkzcm650c1lchj28hj36jx96mklglm41h4q1";
  };

  buildInputs =(with args; [python emacs /* emacs is optional */]);

  preConfigure = ''
    p="$(toPythonPath $out)"
    configureFlags="$configureFlags --with-python=${args.python}/bin/python --with-site-packages=$p"
  '';

  meta = { 
      description = "python debugger with gdb like commands and emacs bindings";
      homepage = http://bashdb.sourceforge.net/pydb/;
      license = "GPLv3";
  };
}
