{ lib
, buildPythonPackage
, internetarchive
, fetchPypi
, yt-dlp
, docopt
, isPy27
}:

buildPythonPackage rec {
  pname = "tubeup";
  version = "0.0.34";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae1e606b243fd70742f8b5871c497628d258ee9f416caa46544aca9a5fbfbca0";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "docopt==0.6.2" "docopt"
  '';

  propagatedBuildInputs = [ internetarchive docopt yt-dlp ];

  pythonImportsCheck = [ "tubeup" ];

  # Tests failing upstream
  doCheck = false;

  meta = with lib; {
    description = "Youtube (and other video site) to Internet Archive Uploader";
    homepage = "https://github.com/bibanon/tubeup";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.marsam ];
  };
}
