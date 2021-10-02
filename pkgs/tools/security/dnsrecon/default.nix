{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnsrecon";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = pname;
    rev = version;
    sha256 = "1ysf8wx287psfk89r0i2vgnrjvxdj44s6nhf6sva59jbwvr9lghy";
  };

  format = "other";

  pythonPath = with python3.pkgs; [
    dnspython netaddr lxml
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
    description = "DNS Enumeration Script";
    homepage = "https://github.com/darkoperator/dnsrecon";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ c0bw3b fab ];
  };
}
