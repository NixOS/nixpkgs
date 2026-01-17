{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  version,
  hash,
}:
stdenvNoCC.mkDerivation {
  pname = "nextcloud-documentation";
  inherit version;

  src = fetchFromGitHub {
    inherit hash;
    owner = "nextcloud";
    repo = "documentation";
    tag = "v${version}";
    fetchSubmodules = true; # TODO: Only needed for 31, can be removed later
  };

  nativeBuildInputs = with python3.pkgs; [
    sphinx
    sphinx-rtd-theme
    sphinx-rtd-dark-mode
    sphinx-copybutton
    sphinx-notfound-page
    sphinx-toolbox
    sphinxcontrib-mermaid
  ];

  postPatch = ''
    patchShebangs --build build/change_file_extension.sh
  '';

  buildPhase = ''
    # The default copyright notice uses the current year at build time, but this does not work as intended in nix.
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

  meta = {
    description = "User and admin documentation for Nextcloud";
    homepage = "https://docs.nextcloud.com";
    teams = [ lib.teams.nextcloud ];
    license = lib.licenses.cc-by-30;
    platforms = lib.platforms.all;
  };
}
