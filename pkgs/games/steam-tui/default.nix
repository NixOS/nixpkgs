{
  lib,
  rustPlatform,
  steamcmd,
  fetchFromGitHub,
  steam-run,
  openssl,
  pkg-config,
  runtimeShell,
  withWine ? false,
  wine,
}:

rustPlatform.buildRustPackage rec {
  pname = "steam-tui";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "dmadisetti";
    repo = pname;
    rev = version;
    sha256 = "sha256-3vBIpPIsh+7PjTuNNqp7e/pdciOYnzuGkjb/Eks6QJw=";
  };

  cargoHash = "sha256-poNPdrMguV79cwo2Eq1dGVUN0E4yG84Q63kU9o+eABo=";

  nativeBuildInputs = [
    openssl
    pkg-config
  ];

  buildInputs = [ steamcmd ] ++ lib.optional withWine wine;

  preFixup = ''
    mv $out/bin/steam-tui $out/bin/.steam-tui-unwrapped
    cat > $out/bin/steam-tui <<EOF
    #!${runtimeShell}
    export PATH=${steamcmd}/bin:\$PATH
    exec ${steam-run}/bin/steam-run $out/bin/.steam-tui-unwrapped '\$@'
    EOF
    chmod +x $out/bin/steam-tui
  '';

  checkFlags = [ "--skip=impure" ];

  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

  meta = with lib; {
    description = "Rust TUI client for steamcmd";
    homepage = "https://github.com/dmadisetti/steam-tui";
    license = licenses.mit;
    maintainers = with maintainers; [
      lom
      dmadisetti
    ];
    # steam only supports that platform
    platforms = [ "x86_64-linux" ];
    mainProgram = "steam-tui";
  };
}
