{ lib, fetchFromGitHub, buildPythonPackage, pkgconfig, lxml, xmlsec, libtool, libxml2, libxslt }:

buildPythonPackage rec {
  pname = "xmlsec";
  version = "1.3.6";

  # 1.3.6 not available on PyPI (https://github.com/mehcode/python-xmlsec/issues/89)
  src = fetchFromGitHub {
    owner = "mehcode";
    repo = "python-xmlsec";
    rev = version;
    sha256 = "02jw5li5mk2ch3y6xvnd4w0r4gjrkws6k8ah461ijcv8pc2hxg0q";
  };

  buildInputs = [ libtool libxml2 libxslt ];

  # TODO: is it possible to only depend on pkgconfig at build time?
  propagatedBuildInputs = [ pkgconfig lxml xmlsec ];

  # “import xmlsec” in tests requires libxmlsec1-openssl to be available
  # TODO: how do we propagate this, so that other packages importing xmlsec
  # do not crash with “SystemError: null argument to internal routine”
  LD_LIBRARY_PATH = lib.makeLibraryPath [ xmlsec ];
  
  # TODO: fix tests
  # https://github.com/mehcode/python-xmlsec/issues/84
  doCheck = false;

  meta = with lib; {
    description = "Python bindings for the XML Security Library";
    homepage = https://github.com/mehcode/python-xmlsec;
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
