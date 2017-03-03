{ stdenv, fetchFromGitHub, python3, python3Packages }:

assert stdenv.isLinux;

python3Packages.buildPythonApplication rec {
  name = "trash-cli-${version}";
  version = "0.17.1.14";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = "${version}";
    sha256 = "1bqazna223ibqjwbc1wfvfnspfyrvjy8347qlrgv4cpng72n7gfi";
  };

  buildInputs = with python3Packages; [ nose mock ];

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = https://github.com/andreafrancia/trash-cli;
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
