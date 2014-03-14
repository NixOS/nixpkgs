{ stdenv, bash, writeScript }:

let

  nix-run = writeScript "nix-run" ''
    #!${bash}/bin/bash

    # Runs nix-build and executes the result
    # All arguments before "--" are given to nix-build,
    # and all arguments after "--" are given to the
    # executed command. stdin is redirected to the executed
    # command.

    out=$(mktemp)
    rm "$out"

    # parse args into args1 and args2, separated by --
    # args1 goes to nix-build, args2 goes to the built command
    args1=("$@")
    args2=()
    for i in "''${!args1[@]}"; do
      if [ "''${args1[$i]}" == "--" ]; then
        args2=("''${args1[@]:$((i+1))}")
        args1=("''${args1[@]:0:$((i))}")
        break
      fi
    done

    if nix-build -o "$out" "''${args1[@]}" >/dev/null; then
      target=$(readlink -m "$out")
      unlink "$out"
      if test -f "$target" && test -x "$target"; then
        exec "$target" "''${args2[@]}" <&0
      else
        echo "nix-run: No executable target produced by nix-build"
        exit 1
      fi
    else
      echo "nix-run: nix-build failed"
      exit 1
    fi
  '';

in stdenv.mkDerivation {
  name = "nix-run";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${nix-run} $out/bin/nix-run
  '';
  meta = {
    description = ''
      Wrapper around nix-build that automatically executes the binary
      produced by the provided Nix expression.
    '';
    longDescription = ''
      nix-run invokes nix-build with any options given to it. It then
      expects one executable file to be produced by nix-build. If this
      is the case, that file is executed with any options that is given
      to nix-run after a <literal>--</literal> option separator. If no
      executable file is produced by nix-build, nix-run will exit with
      an error. An example invocation of nix-run is <literal>nix-run -A
      myattr mynix.nix -- -o opt</literal>. nix-run will then build the
      attribute <literal>myattr</literal> from the Nix expression given
      in the file <literal>mynix.nix</literal>. If a single executable
      file is produced, that file is executed with the option
      <literal>-o opt</literal>.
    '';
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = stdenv.lib.platforms.linux;
  };
}
