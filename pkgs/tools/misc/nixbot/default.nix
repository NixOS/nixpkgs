{ stdenv, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  name = "nixbot-unstable-2017-10-29";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "nixbot";
    rev = "1996d718ff692a5840efa691418526a4faafc89f";
    sha256 = "1jajkpl86nd9d7y1qzx8w8c3ak5hfb365kqlmvq6snvx4j1q4aw0";
  };

  propagatedBuildInputs = with python3.pkgs; [
    PyGithub flask flask_migrate flask_sqlalchemy celery redis
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Github bot for reviewing/testing pull requests with the help of Hydra";
    maintainers = with maintainers; [ domenkozar fpletz globin ];
    license = licenses.asl20;
    homepage = https://github.com/mayflower/nixbot;
  };
}
