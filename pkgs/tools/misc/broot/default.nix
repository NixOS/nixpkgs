{ lib
, stdenv
, rustPlatform
, fetchCrate
, installShellFiles
, makeWrapper
, pkg-config
, libgit2
, oniguruma
, libiconv
, Security
, libxcb
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "1.16.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1R6Q1xRV8FG8IMwZ+u7BJBvIqT1Pgah3emA1oln5hS0=";
  };

  cargoHash = "sha256-+Q5rdOEN7arIyj+2n2JRtr8kRQgXmlxq3jumpuDiYdE=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = [ libgit2 oniguruma libxcb ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    Security
    zlib
  ];

  RUSTONIG_SYSTEM_LIBONIG = true;

  postPatch = ''
    # Fill the version stub in the man page. We can't fill the date
    # stub reproducibly.
    substitute man/page man/broot.1 \
      --replace "#version" "${version}"
  '';

  postInstall = ''
    # Do not nag users about installing shell integration, since
    # it is impure.
    wrapProgram $out/bin/broot \
      --set BR_INSTALL no

    # Install shell function for bash.
    $out/bin/broot --print-shell-function bash > br.bash
    install -Dm0444 -t $out/etc/profile.d br.bash

    # Install shell function for zsh.
    $out/bin/broot --print-shell-function zsh > br.zsh
    install -Dm0444 br.zsh $out/share/zsh/site-functions/br

    # Install shell function for fish
    $out/bin/broot --print-shell-function fish > br.fish
    install -Dm0444 -t $out/share/fish/vendor_functions.d br.fish

    # install shell completion files
    OUT_DIR=$releaseDir/build/broot-*/out

    installShellCompletion --bash $OUT_DIR/{br,broot}.bash
    installShellCompletion --fish $OUT_DIR/{br,broot}.fish
    installShellCompletion --zsh $OUT_DIR/{_br,_broot}

    installManPage man/broot.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/broot --version | grep "${version}"
  '';

  meta = with lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    changelog = "https://github.com/Canop/broot/releases/tag/v${version}";
    maintainers = with maintainers; [ dywedir ];
    license = with licenses; [ mit ];
  };
}
