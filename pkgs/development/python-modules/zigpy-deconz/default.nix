{ stdenv, buildPythonPackage, fetchPypi
, pyserial-asyncio, zigpy
, pytest }:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "049k6lvgf6yjkinbbzm7gqrzqljk2ky9kfw8n53x8kjyfmfp71i2";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ pyserial-asyncio zigpy ];

  meta = with stdenv.lib; {
    description = "A library which communicates with Deconz radios for zigpy";
    homepage = http://github.com/zigpy/zigpy-deconz;
    license = licenses.gpl3;
    maintainers = with maintainers; [ elseym ];
  };
}
