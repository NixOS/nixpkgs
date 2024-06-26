{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "log4j-scan";
  version = "unstable-2021-12-18";
  format = "other";

  src = fetchFromGitHub {
    owner = "fullhunt";
    repo = pname;
    rev = "070fbd00f0945645bd5e0daa199a554ef3884b95";
    sha256 = "sha256-ORSc4KHyAMjuA7QHReDh6SYY5yZRunBBN1+lkCayqL4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pycryptodome
    requests
    termcolor
  ];

  postPatch = ''
    substituteInPlace log4j-scan.py \
      --replace "headers.txt" "../share/headers.txt"
  '';

  installPhase = ''
    runHook preInstall

    install -vD ${pname}.py $out/bin/${pname}
    install -vD headers.txt headers-large.txt -t $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Scanner for finding hosts which are vulnerable for log4j";
    mainProgram = "log4j-scan";
    homepage = "https://github.com/fullhunt/log4j-scan";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
