{ lib
, fetchFromGitHub
, makeWrapper
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sherlock";
  version = "unstable-2023-10-06";
  format = "other";

  src = fetchFromGitHub {
    owner = "sherlock-project";
    repo = pname;
    rev = "7ec56895a37ada47edd6573249c553379254d14a";
    hash = "sha256-bK5yEdh830vgKcsU3gLH7TybLncnX6eRIiYPUiVWM74=";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3.pkgs; [
    certifi
    colorama
    pandas
    pysocks
    requests
    requests-futures
    stem
    torrequest
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -R ./sherlock $out/share

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${python3.interpreter} $out/bin/sherlock \
      --add-flags $out/share/sherlock/sherlock.py \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  checkInputs = with python3.pkgs; [
    exrex
  ];

  checkPhase = ''
    runHook preCheck

    cd $out/share/sherlock
    for tests in all test_multiple_usernames; do
      ${python3.interpreter} -m unittest tests.$tests --verbose
    done

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://sherlock-project.github.io/";
    description = "Hunt down social media accounts by username across social networks";
    license = licenses.mit;
    mainProgram = "sherlock";
    maintainers = with maintainers; [ applePrincess ];
  };
}
