{ stdenv , python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "doge";
  version = "3.5.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0lwdl06lbpnaqqjk8ap9dsags3bzma30z17v0zc7spng1gz8m6xj";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/thiderman/doge;
    description = "wow very terminal doge";
    license = licenses.mit;
    maintainers = with maintainers; [ Gonzih ];
  };
}
