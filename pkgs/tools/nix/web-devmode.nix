{
  pkgs,
  # arguments to `nix-build`, e.g. `"foo.nix -A bar"`
  buildArgs,
  # what path to open a browser at
  open,
}:
let
  inherit (pkgs) lib;

  error_page = pkgs.writeShellScriptBin "error_page" ''
    echo "<!DOCTYPE html>
    <html>
    <head>
      <style>
        @media (prefers-color-scheme: dark) {
          :root { filter: invert(100%); }
        }
      </style>
    </head>
    <body><pre>$1</pre></body>
    </html>"
  '';

  # The following would have been simpler:
  # 1. serve from `$serve`
  # 2. pass each build a `--out-link $serve/result`
  # But that way live-server does not seem to detect changes and therefore no
  # auto-reloads occur.
  # Instead, we copy the contents of each build to the `$serve` directory.
  # Using rsync here, instead of `cp`, to get as close to an atomic
  # directory copy operation as possible. `--delay-updates` should
  # also go towards that.
  build_and_copy = pkgs.writeShellScriptBin "build_and_copy" ''
    set -euxo pipefail

    set +e
    stderr=$(2>&1 nix-build --out-link $out_link ${buildArgs})
    exit_status=$?
    set -e

    if [ $exit_status -eq 0 ];
    then
      # setting permissions to be able to clean up
      ${lib.getBin pkgs.rsync}/bin/rsync \
        --recursive \
        --chmod=u=rwX \
        --delete-before \
        --delay-updates \
        $out_link/ \
        $serve/
    else
      set +x
      ${lib.getBin error_page}/bin/error_page "$stderr" > $error_page_absolute
      set -x

      ${lib.getBin pkgs.findutils}/bin/find $serve \
        -type f \
        ! -name $error_page_relative \
        -delete
    fi
  '';

  # https://watchexec.github.io/
  watcher = pkgs.writeShellScriptBin "watcher" ''
    set -euxo pipefail

    ${lib.getBin pkgs.watchexec}/bin/watchexec \
      --shell=none \
      --restart \
      --print-events \
      ${lib.getBin build_and_copy}/bin/build_and_copy
  '';

  # A Rust alternative to live-server exists, but it was not in nixpkgs.
  # `--no-css-inject`: without this it seems that only CSS is auto-reloaded.
  # https://www.npmjs.com/package/live-server
  server = pkgs.writeShellScriptBin "server" ''
    set -euxo pipefail

    ${lib.getBin pkgs.nodePackages_latest.live-server}/bin/live-server \
      --host=127.0.0.1 \
      --verbose \
      --no-css-inject \
      --entry-file=$error_page_relative \
      --open=${open} \
      $serve
  '';

  devmode = pkgs.writeShellScriptBin "devmode" ''
    set -euxo pipefail

    function handle_exit {
      rm -rf "$tmpdir"
    }

    tmpdir=$(mktemp -d)
    trap handle_exit EXIT

    export out_link="$tmpdir/result"
    export serve="$tmpdir/serve"
    mkdir $serve
    export error_page_relative=error.html
    export error_page_absolute=$serve/$error_page_relative
    ${lib.getBin error_page}/bin/error_page "building …" > $error_page_absolute

    ${lib.getBin pkgs.parallel}/bin/parallel \
      --will-cite \
      --line-buffer \
      --tagstr '{/}' \
      ::: \
      "${lib.getBin watcher}/bin/watcher" \
      "${lib.getBin server}/bin/server"
  '';
in
devmode
