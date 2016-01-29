{ fetchFromGitHub, pythonPackages, stdenv }:

stdenv.mkDerivation rec {
  name = "b2-${version}";
  version = "git-26.01.2016";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "b3f06fd53eb1c9a07740b962284753cba413a7b8";
    sha256 = "0kn2lkh8hp6g8q88glyz03z1r8a47pqm91dc5w083i334swqkjp2";
  };

  buildInputs = [ pythonPackages.wrapPython ];

  installPhase = ''
    mkdir -p $out/bin
    cp b2 $out/bin
  '';

  postInstall = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    homepage = https://github.com/Backblaze/B2_Command_Line_Tool;
    description = "CLI for accessing Backblaze's B2 Cloud Storage";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrdinka ];
  };
}
