{
  lib,
  fetchFromGitLab,
  libplasma,
  nix-update-script,
}:

let
  version = "6.7.4-unstable-2026-08-07";
in
(libplasma.overrideAttrs (old: {
  pname = "aerothemeplasma-libplasma";
  inherit version;

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitgud.io";
    owner = "aeroshell";
    repo = "libplasma";
    rev = "da45ff7247e42afec0fa84e32ca851bc8773378b";
    hash = "sha256-ci/z9YaQxoYG70FUG9fCYi2zeepGMgHWO5AumdIE8Ck=";
  };

  # Stock release patches do not apply to the fork, so drop them
  patches = [ ];

  passthru = (old.passthru or { }) // {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch=Plasma/${lib.versions.majorMinor version}" ];
    };
  };

  meta = old.meta // {
    description = "Foundational libraries, components, and tools of the Plasma workspaces";
    homepage = "https://gitgud.io/aeroshell/libplasma";
    maintainers = with lib.maintainers; [ aaravrav ];
    teams = [ ];
    broken = lib.versions.majorMinor version != lib.versions.majorMinor libplasma.version;
  };
}))
