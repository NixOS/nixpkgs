{ lib
, buildGoModule
, fetchgit
, writeShellScript
, unstableGitUpdater
, sd
}:

buildGoModule rec {
  pname = "goperf";
  version = "0-unstable-2024-06-04";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "3b48cf0e01640b30e676c2d0ffe23b85992be961";
    hash = "sha256-QOTTBc0pxVU2wf1BJt2GiTs28AuMlrjJ50J47EmQt+U=";
  };

  vendorHash = "sha256-O1FxOtRcg4zM2X1YcVFBsy1OsRMZXmAT0ZmGWmCn81g=";

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
