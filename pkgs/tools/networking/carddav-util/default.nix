{ lib, stdenv, fetchgit, python3Packages, makeWrapper }:

stdenv.mkDerivation {

  name = "carddav-0.1-2014-02-26";

  src = fetchgit {
    url = "git://github.com/ljanyst/carddav-util";
    rev = "53b181faff5f154bcd180467dd04c0ce69405564";
    sha256 = "0f0raffdy032wlnxfck6ky60r163nhqfbr311y4ry55l60s4497n";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3Packages; [ requests vobject lxml ];

  strictDeps = true;

  doCheck = false; # no test

  installPhase = ''
    mkdir -p $out/bin
    cp $src/carddav-util.py $out/bin

    pythondir="$out/lib/${python3Packages.python.sitePackages}"
    mkdir -p "$pythondir"
    cp $src/carddav.py "$pythondir"
  '';

  preFixup = ''
    wrapProgram "$out/bin/carddav-util.py" \
      --prefix PYTHONPATH : "$PYTHONPATH:$(toPythonPath $out)" \
      --prefix PATH : "$prefix/bin:$PATH"
  '';

  meta = with lib; {
    homepage = "https://github.com/ljanyst/carddav-util";
    description = "A CardDAV import/export utility";
    platforms = platforms.unix;
    license = licenses.isc;
  };
}
