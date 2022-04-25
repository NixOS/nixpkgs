{ stdenvNoCC, lib, fetchFromGitea, bash, dialog, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "kabeljau";
  version = "1.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "papojari";
    repo = "kabeljau";
    rev = "v${version}";
    sha256 = "sha256-LOvr5fgSUTXnYhbVmynCCjo0W098jKWQnFULtIprE3M=";
  };

  nativeBuildInputs = [ makeWrapper ];
  postPatch = ''
    patchShebangs --host ${pname}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ${pname}.sh $out/bin/${pname}
    wrapProgram $out/bin/${pname} --suffix PATH : ${
      lib.makeBinPath [ dialog ]
    }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Survive as a stray cat in an ncurses game";
    homepage = "https://codeberg.org/papojari/kabeljau";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ papojari ];
  };
}
