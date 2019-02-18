{ stdenv, python, fetchFromGitHub }:

python.pkgs.buildPythonApplication rec {
  pname = "targetcli";
  version = "2.1.fb49";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    sha256 = "093dmwc5g6yz4cdgpbfszmc97i7nd286w4x447dvg22hvwvjwqhh";
  };

  propagatedBuildInputs = with python.pkgs; [ configshell rtslib ];

  meta = with stdenv.lib; {
    description = "A command shell for managing the Linux LIO kernel target";
    homepage = https://github.com/open-iscsi/targetcli-fb;
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
