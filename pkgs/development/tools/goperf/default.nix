{ lib
, buildGoModule
, fetchgit
, writeShellScript
, unstableGitUpdater
, sd
}:

buildGoModule rec {
  pname = "goperf";
  version = "0-unstable-2024-07-07";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "dc66afd55b77cd4e555203ff2c0d3e4d219a1410";
    hash = "sha256-necbttrRRVcbe4JOFBFNvAl2CPOXe8bC7qPLb8qXJSE=";
  };

  vendorHash = "sha256-LJ8eNjOufTvLj1939nYkQOi84ZlT8zSGnTztcEKigfY=";

  passthru.updateScript = writeShellScript "update-goperf" ''
    export UPDATE_NIX_ATTR_PATH=goperf
    ${lib.escapeShellArgs (unstableGitUpdater { inherit (src) url; })}
    set -x
    oldhash="$(nix-instantiate . --eval --strict -A "goperf.goModules.drvAttrs.outputHash" | cut -d'"' -f2)"
    newhash="$(nix-build -A goperf.goModules --no-out-link 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"
    fname="$(nix-instantiate --eval -E 'with import ./. {}; (builtins.unsafeGetAttrPos "version" goperf).file' | cut -d'"' -f2)"
    ${lib.getExe sd} --string-mode "$oldhash" "$newhash" "$fname"
  '';

  meta = with lib; {
    description = "Tools and packages for analyzing Go benchmark results";
    homepage = "https://cs.opensource.google/go/x/perf";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ pbsds ];
  };
}
