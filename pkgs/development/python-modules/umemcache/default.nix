{ stdenv, buildPythonPackage, isPy3k, fetchurl }:

buildPythonPackage rec {
  name = "umemcache-${version}";
  version = "1.6.3";
  disabled = isPy3k;

  src = fetchurl {
    url = "mirror://pypi/u/umemcache/${name}.zip";
    sha256 = "211031a03576b7796bf277dbc9c9e3e754ba066bbb7fb601ab5c6291b8ec1918";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Ultra fast memcache client written in highly optimized C++ with Python bindings";
    homepage = https://github.com/esnme/ultramemcache;
    license = licenses.bsdOriginal;
  };
}
