{ fetchFromGitHub, pythonPackages, stdenv }:

pythonPackages.buildPythonPackage rec {
  name = "b2-${version}";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "v${version}";
    sha256 = "1g9j5s69w6n70nb18rvx3gm9f4gi1vis23ib8rn2v1khv6z2acqp";
  };

  pythonPath = [ pythonPackages.six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Backblaze/B2_Command_Line_Tool;
    description = "CLI for accessing Backblaze's B2 Cloud Storage";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrdinka ];
  };
}
