{ lib
, fetchFromGitHub
, python3
, anki
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ankisyncd";
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "ankicommunity";
    repo = "anki-sync-server";
    rev = version;
    sha256 = "196xhd6vzp1ncr3ahz0bv0gp1ap2s37j8v48dwmvaywzayakqdab";
  };
  format = "other";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python3.sitePackages}

    cp -r ankisyncd utils ankisyncd.conf $out/${python3.sitePackages}
    mkdir $out/share
    cp ankisyncctl.py $out/share/

    runHook postInstall
  '';

  fixupPhase = ''
    PYTHONPATH="$PYTHONPATH:$out/${python3.sitePackages}:${anki}"

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

  propagatedBuildInputs = [ anki ];

  checkPhase = ''
    # Exclude tests that require sqlite's sqldiff command, since
    # it isn't yet packaged for NixOS, although 2 PRs exist:
    # - https://github.com/NixOS/nixpkgs/pull/69112
    # - https://github.com/NixOS/nixpkgs/pull/75784
    # Once this is merged, these tests can be run as well.
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
