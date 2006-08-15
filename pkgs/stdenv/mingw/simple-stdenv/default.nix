{ system
, name
, shell
, path
, extraEnv ? {}
, extraShellOptions ? []
}:

let {
  body = 
    derivation ({
      inherit system name;
      initialPath = path;
      builder = shell;
      args = extraShellOptions ++ ["-e" ./builder.sh];
    } // extraEnv)

    // {
      mkDerivation = attrs:
        derivation ((removeAttrs attrs ["meta"]) // {
          builder = shell;
          args = extraShellOptions ++ ["-e" attrs.builder];
          stdenv = body;
          system = body.system;
        }

        // extraEnv);

      inherit shell;
    };
}
