{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "log4j-scan";
  version = "unstable-2021-12-14";
  format = "other";

  src = fetchFromGitHub {
    owner = "fullhunt";
    repo = pname;
    rev = "7be0f1c02ce3494469dc73a177e6f0c96f0016d9";
    sha256 = "sha256-HazxK0wJ8xeFauD2xOxmOwWw1nEpQh+QdcBVZNaUgrM=";
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
    homepage = "https://github.com/fullhunt/log4j-scan";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
