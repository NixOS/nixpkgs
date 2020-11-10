{ python, stdenv }:

with python.pkgs;

buildPythonApplication rec {
  pname = "chkcrontab";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gmxavjkjkvjysgf9cf5fcpk589gb75n1mn20iki82wifi1pk1jn";
  };

  meta = with stdenv.lib; {
    description = "A tool to detect crontab errors";
    license = licenses.asl20;
    maintainers = with maintainers; [ ma27 ];
    homepage = "https://github.com/lyda/chkcrontab";
  };
}
