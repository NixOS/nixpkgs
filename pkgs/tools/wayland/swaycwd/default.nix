{ lib
, nimPackages
, fetchFromGitLab
, enableShells ? [ "bash" "zsh" "fish" "sh" "posh" ]
}:
nimPackages.buildNimPackage rec{
  pname = "swaycwd";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "cab404";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VrG3H6oTeYsfncdD0IBp3zbmkoF5YF146LRxL064ZAE=";
  };

  preConfigure = ''
    {
      echo 'let enabledShells: seq[string] = @${builtins.toJSON enableShells}'
      echo 'export enabledShells'
    } > src/shells.nim
  '';

  nimFlags = [ "--opt:speed" ];

  meta = with lib; {
    homepage = "https://gitlab.com/cab404/swaycwd";
    description = "Returns cwd for shell in currently focused sway window, or home directory if cannot find shell";
    maintainers = with maintainers; [ cab404 ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}
