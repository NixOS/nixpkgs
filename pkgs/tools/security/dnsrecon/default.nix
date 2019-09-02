{ stdenv, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "dnsrecon";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = pname;
    rev = version;
    sha256 = "1ysf8wx287psfk89r0i2vgnrjvxdj44s6nhf6sva59jbwvr9lghy";
  };

  format = "other";

  pythonPath = with python3.pkgs; [
    dns netaddr lxml
  ];

  postPatch = ''
    substituteInPlace dnsrecon.py \
      --replace "namelist.txt" "../share/namelist.txt" \
      --replace "0.9.0" "${version}"
  '';

  installPhase = ''
    runHook preInstall

    install -vD dnsrecon.py $out/bin/dnsrecon
    install -vD namelist.txt subdomains-*.txt -t $out/share
    install -vd $out/${python3.sitePackages}/
    cp -R lib tools msf_plugin $out/${python3.sitePackages}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "DNS Enumeration Script";
    homepage = "https://github.com/darkoperator/dnsrecon";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ c0bw3b ];
  };
}
