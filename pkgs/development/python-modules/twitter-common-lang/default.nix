{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "twitter.common.lang";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bpZ8orW7lup0nSEFL0WxjjfetcwWDrEsZKjxy526eiI=";
  };

  meta = with lib; {
    description = "Twitter's 2.x / 3.x compatibility swiss-army knife";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
