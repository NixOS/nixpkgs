{
  lib,
  buildPythonPackage,
  fetchPypi,
  twitter-common-lang,
}:

buildPythonPackage rec {
  pname = "twitter.common.collections";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7eTK/3SSgVb3/zjaybCBGJPeQZZsOc1bL96lNBg0nKg=";
  };

  propagatedBuildInputs = [ twitter-common-lang ];

  meta = with lib; {
    description = "Twitter's common collections";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
