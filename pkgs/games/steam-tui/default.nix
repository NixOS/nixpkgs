{ lib
, rustPlatform
, steamcmd
, fetchFromGitHub
, openssl
, pkg-config
, runtimeShell
, steam-run
, withWine ? false
, wine
}:

rustPlatform.buildRustPackage rec {
  pname = "steam-tui";
  # 0.2.1 has build issues for the tests a later commit cleaned up
  # (additional unreleased enchancements have been added as well)
  version = "unstable-2022-12-24";

  src = fetchFromGitHub {
    owner = "dmadisetti";
    repo = pname;
    rev = "236a3b592c23d576730f6c168db33affb7dbff5a";
    sha256 = "czNId8LBaI8T6ot/1xG/xfS34DMwpAC47WglGNLJF+8=";
  };

  cargoSha256 = "M7AOlfzRhmhDKYJCG9R9iJUtpgmI8I24wUTh4cI9S/c=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl steamcmd ]
    ++ lib.optional withWine wine;

  checkFlags = [ "--skip=impure" ];

  preFixup = ''
    mv $out/bin/steam-tui $out/bin/.steam-tui-unwrapped
    cat > $out/bin/steam-tui <<EOF
    #!${runtimeShell}
    export PATH=${steamcmd}/bin:\$PATH
    exec ${steam-run}/bin/steam-run $out/bin/.steam-tui-unwrapped '\$@'
    EOF
    chmod +x $out/bin/steam-tui
  '';

  meta = with lib; {
    description = "Rust TUI client for steamcmd";
    homepage = "https://github.com/dmadisetti/steam-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
    # steam only supports that platform
    platforms = [ "x86_64-linux" ];
  };
}
