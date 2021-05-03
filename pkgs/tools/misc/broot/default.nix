{ lib
, stdenv
, rustPlatform
, fetchCrate
, installShellFiles
, makeWrapper
, libiconv
, zlib
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "1.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Iz9pXvgPIGUnfbnvk5kYAqlrMlz3I2kLszPe8GwwHVk=";
  };

  cargoHash = "sha256-eECAaTUgqasuDhLSk8p/CWSQmV8yV30UoMy3GZCRbGE=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
    zlib
  ];

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

  meta = with lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ danieldk ];
    license = with licenses; [ mit ];
  };
}
