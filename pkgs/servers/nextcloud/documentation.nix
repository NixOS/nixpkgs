{
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  bash,
  rev,
  hash,
}:
stdenvNoCC.mkDerivation {
  name = "nextcloud-documentation";

  src = fetchFromGitHub {
    inherit rev hash;
    owner = "nextcloud";
    repo = "documentation";
  };

  nativeBuildInputs = with python3.pkgs; [
    sphinx
    sphinx-rtd-theme
    sphinx-rtd-dark-mode
    sphinx-copybutton
    sphinxcontrib-mermaid
  ];

  patchPhase = ''
    substituteInPlace build/change_file_extension.sh --replace-fail "#!/bin/bash" "#!${bash}/bin/bash"
  '';

  buildPhase = ''
    # The default copyright notice uses the current year at buildtime, but this does not work as intended in nix.
    echo "copyright = 'Nextcloud GmbH and Nextcloud contributors'" >> conf.py

    pushd user_manual
    make html-allow-warnings-lang-en
    make pdf
    rm -r _build/html/en/{_sources,.buildinfo}
    popd

    pushd admin_manual
    make html-release
    rm -r _build/html/release/.buildinfo
    popd
  '';

  installPhase = ''
    mkdir $out
    cp -r user_manual/_build/html/en $out/user
    cp -r user_manual/_build/pdf/NextcloudUserManual.pdf "$out/Nextcloud Manual.pdf"
    cp -r admin_manual/_build/html/release $out/admin
  '';
}
