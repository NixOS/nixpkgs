{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smbscan";
  version = "unstable-2022-05-26";
  format = "other";

  src = fetchFromGitHub {
    owner = "jeffhacks";
    repo = pname;
    rev = "1b19d6040cab279b97bf002934bf6f8b34d6a8b4";
    hash = "sha256-cL1mnyzIbHB/X4c7sZKVv295LNnjqwR8TZBMe9s/peg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    python-slugify
  ];

  installPhase = ''
    runHook preInstall

    install -vD smbscan.py $out/bin/smbscan
    install -vd $out/${python3.sitePackages}/
    cp {scan_internals,scan,setup,local_logging,arg_parser}.py $out/${python3.sitePackages}
    install -vd $out/${python3.sitePackages}/wordlists/
    cp wordlists/pattern* $out/${python3.sitePackages}/wordlists

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to enumerate file shares";
    homepage = "https://github.com/jeffhacks/smbscan";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "smbscan";
  };
}
