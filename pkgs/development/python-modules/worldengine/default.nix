{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gdal,
  h5py,
  noise,
  numpy,
  protobuf,
  purepng,
  pyplatec,
  six,
  isPy27,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "worldengine";
  version = "0.19.0";
  format = "setuptools";

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

  propagatedBuildInputs = [
    gdal
    h5py
    noise
    numpy
    protobuf
    purepng
    pyplatec
    six
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace pypng>=0.0.18 purepng \
      --replace 'numpy>=1.9.2, <= 1.10.0.post2' 'numpy' \
      --replace 'argparse==1.2.1' "" \
      --replace 'protobuf==3.0.0a3' 'protobuf' \
      --replace 'noise==1.2.2' 'noise' \
      --replace 'PyPlatec==1.4.0' 'PyPlatec' \

    substituteInPlace \
      worldengine/{draw.py,hdf5_serialization.py} \
      --replace numpy.float float
  '';

  doCheck = !isPy27; # google namespace clash
  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "TestSerialization" ];

  meta = with lib; {
    broken = true;
    homepage = "https://github.com/mindwerks/worldengine";
    description = "World generator using simulation of plates, rain shadow, erosion, etc";
    license = licenses.mit;
    maintainers = with maintainers; [ rardiol ];
  };
}
