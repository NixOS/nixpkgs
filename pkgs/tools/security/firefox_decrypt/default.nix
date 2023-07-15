{ lib
, fetchFromGitHub
, buildPythonApplication
, setuptools
, nss
, nix-update-script
}:

buildPythonApplication rec {
  pname = "firefox_decrypt";
  version = "unstable-2023-07-06";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
    rev = "2c61b27e6754cdf6a518ea617d05433f5ccf9f39";
    sha256 = "sha256-/Q6ET6NJ23eYo0ywYMY5TPYpzPHGDzH5+wEpFdsibh8=";
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
