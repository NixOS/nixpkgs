{ stdenv, buildPythonPackage, fetchPypi, fetchurl }:

buildPythonPackage (rec {
  pname = "urwid";
  version = "1.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18cnd1wdjcas08x5qwa5ayw6jsfcn33w4d9f7q3s29fy6qzc1kng";
  };

  patches = [
    (fetchurl {
      url = https://github.com/urwid/urwid/commit/4b0ed8b6030450e6d99909a7c683e9642e546387.patch;
      sha256 = "0ygghd6wzjqij5szg61l1dsk8b0yv8bwyj3bgxxj1lj4m17zsy5q";
    })
  ];

  meta = with stdenv.lib; {
    description = "A full-featured console (xterm et al.) user interface library";
    homepage = http://excess.org/urwid;
    repositories.git = git://github.com/wardi/urwid.git;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ garbas ];
  };
})
