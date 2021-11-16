{ lib
, nimPackages
, fetchFromGitLab
, enableShells ? [ "bash" "zsh" "fish" "sh" "posh" ]
}:
nimPackages.buildNimPackage rec{

  name = "swaycwd";
  version = "0.0.2";

  src = fetchFromGitLab {
    owner = "cab404";
    repo = name;
    rev = "v${version}";
    hash = "sha256-OZWOPtOqcX+fVQCxWntrn98EzFu70WH55rfYCPDMSKk=";
  };

  preConfigure = ''
    {
      echo 'let enabledShells: seq[string] = @${builtins.toJSON enableShells}'
      echo 'export enabledShells'
    } > shells.nim
    cat << EOF > swaycwd.nimble
    srcDir = "."
    bin = "swaycwd"
    EOF
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
