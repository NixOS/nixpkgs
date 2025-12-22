{
  pkgs ? import ../../.. { },
}:
let
  inherit (pkgs) runCommand;
  # splicing doesn't seem to work right here
  inherit (pkgs.buildPackages) dumpnar rsync;

  pack-env =
    paths:
    pkgs.buildEnv {
      name = "pack-env";
      paths = paths;
      includeClosures = true;
      ignoreCollisions = true;
    };

  pack-all =
    packCmd: name: pkgs: fixups:
    (runCommand name
      {
        nativeBuildInputs = [
          rsync
          dumpnar
        ];
      }
      (
        let
        in
        ''
          rsync --chmod="+w" -av -L --exclude=cygwin1.dll "${pack-env pkgs}"/ .

          base=$PWD
          rm -rf nix nix-support
          mkdir nix-support
          for dir in $requisites; do
            cd "$dir/nix-support" 2>/dev/null || continue
            for f in $(find . -type f); do
              mkdir -p "$base/nix-support/$(dirname $f)"
              cat $f >>"$base/nix-support/$f"
            done
          done
          rm -f $base/nix-support/propagated-build-inputs
          cd $base

          ${fixups}

          ${packCmd}
        ''
      )
    );
  nar-all = pack-all "dumpnar . | xz -9 -e -T $NIX_BUILD_CORES >$out";
  tar-all = pack-all "XZ_OPT=\"-9 -e -T $NIX_BUILD_CORES\" tar cJf $out --hard-dereference --sort=name --numeric-owner --owner=0 --group=0 --mtime=@1 .";
  coreutils-big = pkgs.coreutils.override { singleBinary = false; };
  mkdir = runCommand "mkdir" { coreutils = coreutils-big; } ''
    mkdir -p $out/bin
    cp $coreutils/bin/mkdir.exe $out/bin
  '';

  curl = pkgs.curl.overrideAttrs (old: {
    # these use the build shebang
    # TODO: fix in curl
    postFixup = old.postFixup or "" + ''
      rm "$dev"/bin/curl-config "$bin"/bin/wcurl
    '';
  });
in
rec {
  unpack = nar-all "unpack.nar.xz" (with pkgs; [
    bashNonInteractive
    mkdir
    xz
    gnutar
  ]) "";
  bootstrap-tools = tar-all "bootstrap-tools.tar.xz" (with pkgs; [
    gcc
    # gcc.lib
    curl
    curl.dev
    cygwin.newlib-cygwin
    cygwin.newlib-cygwin.bin
    cygwin.newlib-cygwin.dev
    cygwin.w32api
    cygwin.w32api.dev
    # bintools-unwrapped
    gnugrep
    coreutils
    expand-response-params
  ]) "";
  build = runCommand "build" { } ''
    mkdir -p $out/on-server
    ln -s ${unpack} $out/on-server/unpack.nar.xz
    ln -s ${bootstrap-tools} $out/on-server/bootstrap-tools.tar.xz
  '';
}
