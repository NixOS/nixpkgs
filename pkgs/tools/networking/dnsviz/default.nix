{ lib
, buildPythonApplication
, fetchFromGitHub
, dnspython
, m2crypto
, pygraphviz
}:

buildPythonApplication rec {
  pname = "dnsviz";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "dnsviz";
    repo = "dnsviz";
    rev = "v${version}";
    sha256 = "sha256-tIxjlNtncZJSdfQelIR9fTohBDkyC0+YwEcs2gNfKec=";
  };

  patches = [
    # override DNSVIZ_INSTALL_PREFIX with $out
    ./fix-path.patch
  ];

  propagatedBuildInputs = [
    dnspython
    m2crypto
    pygraphviz
  ];

  postPatch = ''
    substituteInPlace dnsviz/config.py.in --replace '@out@' $out
  '';

  # Tests require network connection and /etc/resolv.conf
  doCheck = false;

  pythonImportsCheck = [ "dnsviz" ];

  meta = with lib; {
    description = "Tool suite for analyzing and visualizing DNS and DNSSEC behavior";
    longDescription = ''
      DNSViz is a tool suite for analysis and visualization of Domain Name System (DNS) behavior,
      including its security extensions (DNSSEC).

      This tool suite powers the Web-based analysis available at https://dnsviz.net/
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jojosch ];
  };
}
