{ lib
, fetchFromGitHub
, buildPythonApplication
, setuptools
, nss
, nix-update-script
}:

buildPythonApplication rec {
  pname = "firefox_decrypt";
  version = "unstable-2023-07-28";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
    rev = "40716a68c3cee1d176d2cdf08a455066fc75a9bb";
    sha256 = "sha256-JqtzNQrLItc68fWAnMkLHCbhhEyw1nxtod1zlqpn8mA=";
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
