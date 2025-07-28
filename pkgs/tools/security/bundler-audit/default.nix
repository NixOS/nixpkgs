{
  bundlerEnv,
  ruby,
  lib,
  bundlerUpdateScript,
}:

bundlerEnv rec {
  name = "${pname}-${version}";
  pname = "bundler-audit";
  version = (import ./gemset.nix).bundler-audit.version;

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "bundler-audit";

  meta = with lib; {
    description = "Patch-level verification for Bundler";
    longDescription = ''
      Features:
      - Checks for vulnerable versions of gems in Gemfile.lock.
      - Checks for insecure gem sources (http://).
      - Allows ignoring certain advisories that have been manually worked around.
      - Prints advisory information.
      - Does not require a network connection.
    '';
    homepage = "https://github.com/rubysec/bundler-audit";
    changelog = "https://github.com/rubysec/bundler-audit/blob/v${version}/ChangeLog.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      nicknovitski
    ];
    platforms = platforms.unix;
  };
}
