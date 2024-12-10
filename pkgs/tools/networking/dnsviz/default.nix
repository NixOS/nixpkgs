{ lib
, buildPythonApplication
, fetchFromGitHub
, dnspython
, m2crypto
, pygraphviz
}:

buildPythonApplication rec {
  pname = "dnsviz";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "dnsviz";
    repo = "dnsviz";
    rev = "v${version}";
    sha256 = "sha256-x6LdPVQFfsJIuKde1+LbFKz5bBEi+Mri9sVH0nGsbCU=";
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
    mainProgram = "dnsviz";
    longDescription = ''
      DNSViz is a tool suite for analysis and visualization of Domain Name System (DNS) behavior,
      including its security extensions (DNSSEC).

      This tool suite powers the Web-based analysis available at https://dnsviz.net/
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jojosch ];
  };
}
