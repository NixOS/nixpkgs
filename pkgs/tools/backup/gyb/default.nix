{ lib
, fetchFromGitHub
, python3
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "gyb";
  version = "1.80";
  format = "other";

  src = fetchFromGitHub {
    owner = "GAM-team";
    repo = "got-your-back";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4xElzhf9R6qnzr4oyZktQy/ym2vEjR9MrHnLYxBiAOg=";
  };

  propagatedBuildInputs = with python3Packages; [
    google-api-python-client
    google-auth
    google-auth-oauthlib
    google-auth-httplib2
    httplib2
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,${python3.sitePackages}}
    mv gyb.py "$out/bin/gyb"
    mv *.py "$out/${python3.sitePackages}/"

    runHook postInstall
  '';

  checkPhase = ''
    $out/bin/gyb --help > /dev/null
  '';

  meta = with lib; {
    description = ''
      Got Your Back (GYB) is a command line tool for backing up your Gmail
      messages to your computer using Gmail's API over HTTPS.
    '';
    homepage = "https://github.com/GAM-team/got-your-back";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
