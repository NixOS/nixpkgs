{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ankisyncd";
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "ankicommunity";
    repo = "anki-sync-server";
    rev = version;
    hash = "sha256-RXrdJGJ+HMSpDGQBuVPPqsh3+uwAgE6f7ZJ0yFRMI8I=";
    fetchSubmodules = true;
  };
  format = "other";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python3.sitePackages}

    cp -r ankisyncd utils ankisyncd.conf $out/${python3.sitePackages}
    cp -r anki-bundled/anki $out/${python3.sitePackages}
    mkdir $out/share
    cp ankisyncctl.py $out/share/

    runHook postInstall
  '';

  fixupPhase = ''
    PYTHONPATH="$PYTHONPATH:$out/${python3.sitePackages}"

    makeWrapper "${python3.interpreter}" "$out/bin/ankisyncd" \
          --set PYTHONPATH $PYTHONPATH \
          --add-flags "-m ankisyncd"

    makeWrapper "${python3.interpreter}" "$out/bin/ankisyncctl" \
          --set PYTHONPATH $PYTHONPATH \
          --add-flags "$out/share/ankisyncctl.py"
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytest
    webtest
  ];

  buildInputs = [ ];

  propagatedBuildInputs = with python3.pkgs; [
    decorator
    requests
  ];

  checkPhase = ''
    # skip these tests, our files are too young:
    # tests/test_web_media.py::SyncAppFunctionalMediaTest::test_sync_mediaChanges ValueError: ZIP does not support timestamps before 1980
    pytest --ignore tests/test_web_media.py tests/
  '';

  meta = with lib; {
    description = "Self-hosted Anki sync server";
    maintainers = with maintainers; [ matt-snider ];
    homepage = "https://github.com/ankicommunity/anki-sync-server";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
  };
}
