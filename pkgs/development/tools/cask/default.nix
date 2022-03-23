{ lib, stdenv, python3, emacs, bash }:

stdenv.mkDerivation rec {
  pname = "cask";

  inherit (emacs.pkgs.melpaStablePackages.cask) src version;

  doCheck = true;

  nativeBuildInputs = [ emacs ];
  buildInputs = with emacs.pkgs; [
    s f dash ansi ecukes servant ert-runner el-mock
    noflet ert-async shell-split-string git package-build
  ] ++ [
    python3
    bash
  ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild

    emacs --batch -L . -f batch-byte-compile cask.el cask-cli.el

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    dir=$out/share/emacs/site-lisp/cask
    install -Dm444 -t $dir     *.el *.elc
    install -Dm555 -t $dir/bin bin/cask
    touch $out/.no-upgrade
    ln -s $dir/bin/cask $out/bin/cask

    runHook postInstall
  '';

  meta = with lib; {
    description = "Project management for Emacs";
    longDescription = ''
      Cask is a project management tool for Emacs that helps automate the
      package development cycle; development, dependencies, testing, building,
      packaging and more.
      Cask can also be used to manage dependencies for your local Emacs configuration.
    '';

    homepage = "https://cask.readthedocs.io/en/latest/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ flexw ];
    platforms = platforms.all;
  };
}
