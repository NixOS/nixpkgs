{ stdenv, fetchFromGitHub, python2Packages }:

let
  bName = "check_esxi_hardware";
  pName = stdenv.lib.replaceStrings [ "_" ] [ "-" ] "${bName}";

in python2Packages.buildPythonApplication rec {
  name = "${pName}-${version}";
  version = "20161013";

  src = fetchFromGitHub {
    owner  = "Napsty";
    repo   = bName;
    rev    = version;
    sha256 = "19zybcg62dqcinixnp1p8zw916x3w7xvy6dlsmn347iigfa5s55s";
  };

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin                ${bName}.py
    install -Dm644 -t $out/share/doc/${pName} README.md

    runHook postInstall
  '';

  propagatedBuildInputs = with python2Packages; [ pywbem ];

  meta = with stdenv.lib; {
    homepage = https://www.claudiokuenzler.com/nagios-plugins/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
