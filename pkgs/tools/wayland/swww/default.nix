{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, lz4
, libxkbcommon
, installShellFiles
, scdoc
}:

rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "LGFae";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-n7YdUmIZGu7W7cX6OvVW+wbkKjFvont4hEAhZXYDQd8=";
  };

  cargoSha256 = "sha256-lZC71M3lbsI+itMydAp5VCz0cpSHo/FpkQFC1NlN4DU=";

  buildInputs = [
    lz4
    libxkbcommon
  ];

  doCheck = false; # Integration tests do not work in sandbox environment

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
  ];

  postInstall = ''
    for f in doc/*.scd; do
      local page="doc/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    installShellCompletion --cmd swww \
      --bash <(cat completions/swww.bash) \
      --fish <(cat completions/swww.fish) \
      --zsh <(cat completions/_swww)
  '';

  meta = with lib; {
    description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
    homepage = "https://github.com/LGFae/swww";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mateodd25 donovanglover ];
    platforms = platforms.linux;
    mainProgram = "swww";
  };
}
