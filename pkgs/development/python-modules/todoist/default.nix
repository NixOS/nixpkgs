{ stdenv, fetchurl, python, buildPythonPackage
, requests }:

buildPythonPackage rec {
  pname = "todoist-python";
  version = "7.0.17";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/t/${pname}/${name}.tar.gz";
    sha256 = "0gs4vlvvmkz627ybswj0l6m3c8dyrqgfqjlawbc8d9rkx88srkr2";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "The official Todoist Python API library";
    homepage = http://todoist-python.readthedocs.io/en/latest/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
