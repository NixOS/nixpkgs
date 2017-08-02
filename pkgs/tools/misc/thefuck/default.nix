{ fetchurl, stdenv, pkgs, ... }:

pkgs.pythonPackages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "thefuck";
  version = "3.18";

  src = fetchurl {
    url = "https://github.com/nvbn/${pname}/archive/${version}.tar.gz";
    sha256 = "1xsvkqh89rgxq5w03mnlcfkn9y39nfwhb2pjabjspcc2mi2mq5y6";
  };

  propagatedBuildInputs = with pkgs.pythonPackages; [
    psutil
    colorama
    six
    decorator
    pathlib2
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/nvbn/thefuck;
    description = "Magnificent app which corrects your previous console command.";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
