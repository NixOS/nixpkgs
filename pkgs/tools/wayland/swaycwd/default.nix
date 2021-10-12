{ lib, nimPackages, fetchFromGitLab
, enableShells ? [ "bash" "zsh" "fish" "sh" "posh" ]
}:

nimPackages.buildNimPackage {
    name = "swaycwd";
    version = "0.0.1";

    src = fetchFromGitLab {
      owner = "cab404";
      repo = "swaycwd";
      rev = "aca81695ec2102b9bca6f5bae364f69a8b9d399f";
      hash = "sha256-MkyY3wWByQo0l0J28xKDfGtxfazVPRyZHCObl9Fszh4=";
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
