{ lib
, buildGoModule
, fetchgit
, writeShellScript
, unstableGitUpdater
, sd
}:

buildGoModule rec {
  pname = "goperf";
  version = "0-unstable-2024-08-06";

  src = fetchgit {
    url = "https://go.googlesource.com/perf";
    rev = "3f62151e343cbb54ce6f792b9e1661c4e4845651";
    hash = "sha256-3JjutGKWSywXEHPw7YhH42EEIAh7PL09m37LokgTpuc=";
  };

  vendorHash = "sha256-dCyw9b7ZZHN//4Nhriw3b4Q5AQ3RWs+H/MtqIq5BvpA=";

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
