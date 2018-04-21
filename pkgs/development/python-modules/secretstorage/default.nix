{ stdenv, fetchFromGitHub, buildPythonPackage
, dbus-python, cryptography }:

buildPythonPackage rec {
  pname = "secretstorage";
  version = "2.3.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mitya57";
    repo = "secretstorage";
    rev = version;
    sha256 = "1sjd2jjbxgkkxyrfwx89x0hsnn39w2cr2qkxbg1iz52znr4sqism";
  };

  propagatedBuildInputs = [ dbus-python cryptography ];

  doCheck = false; # requires dbus session

  meta = with stdenv.lib; {
    homepage = "https://github.com/mitya57/secretstorage";
    description = "Python bindings to FreeDesktop.org Secret Service API";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ teto ];
  };
}
