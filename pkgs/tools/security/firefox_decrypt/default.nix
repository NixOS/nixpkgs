{ lib
, fetchFromGitHub
, buildPythonApplication
, setuptools
, nss
, nix-update-script
}:

buildPythonApplication rec {
  pname = "firefox_decrypt";
  version = "unstable-2023-05-14";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
    rev = "ac857efde75d86dd6bd5dfca25d4a0f73b75009f";
    sha256 = "sha256-34QS98nmrL98nzoZgeFSng8TJJc9BU1+Tzh2b+dsuCc=";
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
