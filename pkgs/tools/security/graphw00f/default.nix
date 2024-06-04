{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "graphw00f";
  version = "1.1.16";
  format = "other";

  src = fetchFromGitHub {
    owner = "dolevf";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-amyW+k6eXc4pyRLgrEXfOmMtReZvS8zDDBy+FSY6wHA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
  ];

  installPhase = ''
    runHook preInstall

    install -vD main.py $out/bin/graphw00f
    install -vD {conf,version}.py -t $out/${python3.sitePackages}/
    install -vD graphw00f/* -t $out/${python3.sitePackages}/graphw00f

    runHook postInstall
  '';
  meta = with lib; {
    description = "GraphQL Server Engine Fingerprinting utility";
    mainProgram = "graphw00f";
    homepage = "https://github.com/dolevf/graphw00f";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
