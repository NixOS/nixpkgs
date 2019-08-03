{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "speaklater";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ab5dbfzzgz6cnz4xlwx79gz83id4bhiw67k1cgqrlzfs0va7zjr";
  };

  meta = with stdenv.lib; {
    description = "Implements a lazy string for python useful for use with gettext";
    homepage = https://github.com/mitsuhiko/speaklater;
    license = licenses.bsd0;
    maintainers = with maintainers; [ matejc ];
  };

}
