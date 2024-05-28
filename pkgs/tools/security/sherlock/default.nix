{ lib
, fetchFromGitHub
, makeWrapper
, python3
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sherlock";
  version = "0-unstable-2024-05-22";
  format = "other";

  src = fetchFromGitHub {
    owner = "sherlock-project";
    repo = "sherlock";
    rev = "ab5fcbb90f592ea97239ceab5e8ca3a8d3f7f08b";
    hash = "sha256-F793Co7CdpNrMFM7SHy/hrmzPKo5hiSHF3BqGtjmJbc=";
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

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    homepage = "https://sherlock-project.github.io/";
    description = "Hunt down social media accounts by username across social networks";
    license = licenses.mit;
    mainProgram = "sherlock";
    maintainers = with maintainers; [ applePrincess ];
  };
}
