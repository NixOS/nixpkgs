{ lib
, fetchFromGitHub
, rustPlatform
, at-spi2-atk
, pkg-config
, glib
, gtk3
, gtk-layer-shell
, installShellFiles
, scdoc
}:

rustPlatform.buildRustPackage rec {
  pname = "wleave";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "AMNatty";
    repo = "wleave";
    rev = version;
    hash = "sha256-RMUwsrDvSErNbulpyJyRSB1NIsG706SCvF50t3VKuWA=";
  };

  cargoHash = "sha256-E7Lw7HIZC8j/1H+M9lfglfMkWDeaAL505qCkj+CV7Ik=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
  ];

  buildInputs = [
    at-spi2-atk
    gtk3
    gtk-layer-shell
    glib
  ];

  postInstall = ''
    for f in man/*.scd; do
      local page="man/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    installShellCompletion --cmd wleave \
      --bash <(cat completions/wleave.bash) \
      --fish <(cat completions/wleave.fish) \
      --zsh <(cat completions/_wleave)
  '';

  meta = with lib; {
    description = "A Wayland-native logout script written in GTK3";
    homepage = "https://github.com/AMNatty/wleave";
    license = licenses.mit;
    mainProgram = "wleave";
    maintainers = with maintainers; [ ludovicopiero ];
    platforms = platforms.linux;
  };
}
