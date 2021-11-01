{ lib, stdenv, fetchFromGitHub, bash, ocaml }:

stdenv.mkDerivation {
  pname = "rescript-editor-analysis";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rescript-vscode";
    rev = "8d0412a72307b220b7f5774e2612760a2d429059";
    sha256 = "rHQtfuIiEWlSPuZvNpEafsvlXCj2Uv1YRR1IfvKfC2s=";
  };

  nativeBuildInputs = [ ocaml ];

  postPatch = ''
    cd analysis
    substituteInPlace Makefile --replace "/bin/bash" "${bash}/bin/bash"
  '';

  installPhase = ''
    install -D -m0555 rescript-editor-analysis.exe $out/bin/rescript-editor-analysis.exe
  '';

  meta = with lib; {
    description = "Analysis binary for the ReScript VSCode plugin";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mit;
  };
}
