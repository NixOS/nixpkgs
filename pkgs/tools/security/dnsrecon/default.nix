{ stdenv, fetchFromGitHub, python2 }:

python2.pkgs.buildPythonApplication rec {
  name = "dnsrecon-${version}";
  version = "0.8.9+git20170501";

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = "dnsrecon";
    rev = "c96739859cc25177df0a9a3a3b7bdcfe62d87394";
    sha256 = "0xs38yqlghqv9qhzzky15ljis7753lzm9bjqyqfn9vwb20czbc48";
  };

  format = "other";

  pythonPath = with python2.pkgs; [
    dns netaddr
  ];

  postPatch = ''
    substituteInPlace dnsrecon.py \
      --replace namelist.txt "../share/namelist.txt"
  '';

  installPhase = ''
    runHook preInstall

    install -vD dnsrecon.py $out/bin/dnsrecon
    install -vD namelist.txt -t $out/share
    install -vd $out/${python2.sitePackages}/
    cp -R lib $out/${python2.sitePackages}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "DNS Enumeration Script";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.globin ];
  };
}
