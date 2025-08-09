{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  unar,
}:

buildPythonApplication rec {
  pname = "unrar-wrapper";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "unrar_wrapper";
    rev = "unrar_wrapper-${version}";
    sha256 = "sha256-HjrUif8MrbtLjRQMAPZ/Y2o43rGSDj0HHY4fZQfKz5w=";
  };

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ unar ]}"
  ];

  postFixup = ''
    ln -s $out/bin/unrar_wrapper $out/bin/unrar
    rm -rf $out/nix-support/propagated-build-inputs
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "https://github.com/openSUSE/unrar_wrapper";
    description = "Backwards compatibility between unar and unrar";
    longDescription = ''
      unrar_wrapper is a wrapper python script that transforms the basic UnRAR commands
      to unar and lsar calls in order to provide a backwards compatibility.
    '';
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ artturin ];
  };
}
