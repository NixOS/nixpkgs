{ stdenv
, buildPythonPackage
, pythonOlder
, isPy27
, fetchFromGitHub
, nose
, noise
, numpy
, pyplatec
, protobuf
, purepng
, h5py
, gdal
}:

buildPythonPackage rec {
  pname = "worldengine";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "Mindwerks";
    repo = "worldengine";
    rev = "v${version}";
    sha256 = "1xrckb0dn2841gvp32n18gib14bpi77hmjw3r9jiyhg402iip7ry";
  };

  src-data = fetchFromGitHub {
    owner = "Mindwerks";
    repo = "worldengine-data";
    rev = "029051e";
    sha256 = "06xbf8gj3ljgr11v1n8jbs2q8pdf9wz53xdgkhpm8hdnjahgdxdm";
  };

  postUnpack = ''
    ln -s ${src-data} worldengine-data
  '';

  propagatedBuildInputs = [ noise numpy pyplatec protobuf purepng h5py gdal ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace pypng>=0.0.18 purepng \
      --replace 'numpy>=1.9.2, <= 1.10.0.post2' 'numpy' \
      --replace 'argparse==1.2.1' "" \
      --replace 'protobuf==3.0.0a3' 'protobuf' \
      --replace 'noise==1.2.2' 'noise' \
      --replace 'PyPlatec==1.4.0' 'PyPlatec' \
  '';

  # with python<3.5, unittest fails to discover tests because of their filenames
  # so nose is used instead.
  doCheck = !isPy27; # google namespace clash
  checkInputs = stdenv.lib.optional (pythonOlder "3.5") [ nose ];
  postCheck = stdenv.lib.optionalString (pythonOlder "3.5") ''
    nosetests tests
  '';

  meta = with stdenv.lib; {
    homepage = "http://world-engine.org";
    description = "World generator using simulation of plates, rain shadow, erosion, etc";
    license = licenses.mit;
    maintainers = with maintainers; [ rardiol ];
  };

}
