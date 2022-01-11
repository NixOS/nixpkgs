{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnsrecon";
  version = "1.0.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = pname;
    rev = version;
    sha256 = "sha256-VRO5ugr/+iZh+hh3tVs/JNAr7GXao/HK43O3FlkbcSM=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    dnspython
    netaddr
    lxml
  ];

  postPatch = ''
    substituteInPlace dnsrecon.py \
      --replace "namelist.txt" "../share/namelist.txt"
  '';

  installPhase = ''
    runHook preInstall

    install -vD dnsrecon.py $out/bin/dnsrecon
    install -vD namelist.txt subdomains-*.txt -t $out/share
    install -vd $out/${python3.sitePackages}/
    cp -R lib tools msf_plugin $out/${python3.sitePackages}

    runHook postInstall
  '';


  meta = with lib; {
    description = "DNS Enumeration script";
    homepage = "https://github.com/darkoperator/dnsrecon";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ c0bw3b fab ];
  };
}
