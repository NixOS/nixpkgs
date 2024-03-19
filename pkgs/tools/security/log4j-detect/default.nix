{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "log4j-detect";
  version = "unstable-2021-12-14";
  format = "other";

  src = fetchFromGitHub {
    owner = "takito1812";
    repo = pname;
    rev = "2f5b7a598a6d0b4aee8111bb574ea72c6a1c76d6";
    sha256 = "sha256-fFKW7uPBfrnze0UoPL3Mfwd4sFOuHYuDP7kv6VtdM3o=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
  ];

  postPatch = ''
    sed -i "1 i #!/usr/bin/python" ${pname}.py
  '';

  installPhase = ''
    runHook preInstall
    install -vD ${pname}.py $out/bin/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to detect the log4j vulnerability";
    homepage = "https://github.com/takito1812/log4j-detect";
    license = licenses.unfree;
    maintainers = with maintainers; [ fab ];
  };
}
