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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "AMNatty";
    repo = "wleave";
    rev = version;
    hash = "sha256-qo9HnaWYsNZH1J8lAyKSwAOyvlCvIsh9maioatjtGkg=";
  };

  cargoHash = "sha256-6Gppf1upWoMi+gcRSeQ1txSglAaBbpOXKs2LoJhslPQ=";

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
