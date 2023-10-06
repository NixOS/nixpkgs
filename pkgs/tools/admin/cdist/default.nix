{ lib
, buildPythonApplication
, fetchFromGitea
, pythonImportsCheckHook
, sphinxHook
, sphinx-rtd-theme
}:

buildPythonApplication rec {
  pname = "cdist";
  version = "7.0.0";
  outputs = [ "out" "man" "doc" ];

  src = fetchFromGitea {
    domain = "code.ungleich.ch";
    owner = "ungleich-public";
    repo = "cdist";
    rev = version;
    hash = "sha256-lIx0RtGQJdY2e00azI9yS6TV+5pCegpKOOD0dQmgMqA=";
  };

  nativeBuildInputs = [
    pythonImportsCheckHook
    sphinxHook
    sphinx-rtd-theme
  ];

  sphinxRoot = "docs/src";

  # "make man" creates symlinks in docs/src needed by sphinxHook.
  postPatch = ''
    echo "VERSION = '$version'" > cdist/version.py

    make man
  '';

  preConfigure = ''
    export HOME=/tmp
  '';

  # Test suite requires either non-chrooted environment or root.
  #
  # When "machine_type" explorer figures out that it is running inside
  # chroot, it assumes that it has enough privileges to escape it.
  doCheck = false;

  pythonImportsCheck = [ "cdist" ];

  postInstall = ''
    mkdir -p $out/share
    mv docs/dist/man $out/share
  '';

  meta = with lib; {
    description = "Minimalistic configuration management system";
    homepage = "https://www.sdi.st";
    changelog = "https://code.ungleich.ch/ungleich-public/cdist/src/tag/${version}/docs/changelog";

    # Mostly. There are still couple types that are gpl3-only.
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kaction ];
    platforms = platforms.unix;
  };
}
