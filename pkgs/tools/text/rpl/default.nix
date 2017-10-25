{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "rpl";
  version = "1.5.7";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchFromGitHub {
    owner  = "kcoyner";
    repo   = "rpl";
    rev    = "v${version}";
    sha256 = "1xhpgcmq91ivy9ijfyz5ilg51m7fz8ar2077r7gq246j8gbf8ggr";
  };

  meta = with stdenv.lib; {
    description = "Replace strings in files";
    homepage    = "https://github.com/kcoyner/rpl";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ teto ];
  };
}
