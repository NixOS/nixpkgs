{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  setuptools,
  setuptools-scm,
  wheel,
  nss,
  nix-update-script,
  stdenv,
}:

buildPythonApplication rec {
  pname = "firefox_decrypt";
  version = "1.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "unode";
    repo = pname;
    tag = "${version}";
    hash = "sha256-HPjOUWusPXoSwwDvW32Uad4gFERvn79ee/WxeX6h3jY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  makeWrapperArgs = [
    "--prefix"
    (if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH")
    ":"
    (lib.makeLibraryPath [ nss ])
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/unode/firefox_decrypt";
    description = "Tool to extract passwords from profiles of Mozilla Firefox and derivates";
    mainProgram = "firefox_decrypt";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      schnusch
      unode
    ];
  };
}
