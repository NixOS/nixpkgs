{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  name = "nixbot-unstable-2016-10-09";

  src = fetchFromGitHub {
    owner = "domenkozar";
    repo = "nixbot";
    rev = "dc490e4954cb08f0eff97f74ad39dedb54670aa9";
    sha256 = "1l8rlhd2b7x5m79vb2vgszachygasv0pk8drnwgxyvsn0k88xcan";
  };

  propagatedBuildInputs = with python3Packages; [
    pygit2 pyramid waitress github3_py
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Github bot for reviewing/testing pull requests with the help of Hydra";
    maintainers = with maintainers; [ domenkozar fpletz globin ];
    license = licenses.asl20;
    homepage = https://github.com/domenkozar/nixbot;
  };
}
