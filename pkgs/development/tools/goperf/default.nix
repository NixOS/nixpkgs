{ lib
, buildGoModule
, fetchgit
, writeShellScript
, unstableGitUpdater
, sd
}:

buildGoModule rec {
  pname = "goperf";
  version = "0-unstable-2024-05-10";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "bedb9135df6d63a551db71a3fa872a2816e90cf2";
    hash = "sha256-e2dr/eeKoc0Vpxx29bmxhfYsj13oEFs9h1/mBmDbWM4=";
  };

  vendorHash = "sha256-MtDvOn+cjlEtObzmYnsQa2BkgIeKr/j18wk5QK3JDuk=";

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
