{ lib
, fetchFromGitHub
, buildPythonApplication
, setuptools
, nss
, nix-update-script
}:

buildPythonApplication rec {
  pname = "firefox_decrypt";
  version = "unstable-2023-07-26";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
    rev = "a3b981efa86ce53503ddbbbd9181ea430965d148";
    sha256 = "sha256-DRkhx6NIZ/RRxxw3/R+kZ13+IAqytBt9endEW9RvCq4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  makeWrapperArgs = [ "--prefix" "LD_LIBRARY_PATH" ":" (lib.makeLibraryPath [ nss ]) ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    homepage = "https://github.com/unode/firefox_decrypt";
    description = "A tool to extract passwords from profiles of Mozilla Firefox and derivates";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ schnusch ];
  };
}
