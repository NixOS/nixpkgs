{ fetchurl, python2, stdenv }:

with python2.pkgs;

buildPythonApplication rec {
  pname = "PySolFC";
  version = "2.0";

  src = fetchurl {
    url = "mirror://sourceforge/pysolfc/${pname}-${version}.tar.bz2";
    sha256 = "0v0v8iflw55f5mghglkw80j8b7lv1hffjassfhqc4y84dmz8xjyv";
  };

  patches = [
    ./pysolfc-datadir.patch
  ];

  propagatedBuildInputs = [
    tkinter
  ];

  # No tests in archive
  doCheck = false;

  postInstall = ''
    # executables should not have an extension
    pushd $out/bin
    mv pysol.py pysol
    rm pysol.pyc
    popd
  '';

  meta = with stdenv.lib; {
    description = "A collection of more than 1000 solitaire card games";
    homepage = http://pysolfc.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ kierdavis ];
  };
}
