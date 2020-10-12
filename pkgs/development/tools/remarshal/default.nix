{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "remarshal";
  version = "0.14.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "16425aa1575a271dd3705d812b06276eeedc3ac557e7fd28e06822ad14cd0667";
  };

  propagatedBuildInputs = with python3Packages; [
    pyyaml cbor2 dateutil tomlkit u-msgpack-python
  ];

  meta = with stdenv.lib; {
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = "https://github.com/dbohdan/remarshal";
    maintainers = with maintainers; [ offline ];
  };
}
