{ stdenv, fetchFromGitHub, nix-update-source, lib, python3
, which, runtimeShell, pylint }:
stdenv.mkDerivation rec {
  version = "0.9.1";
  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gup";
    rev = "version-${version}";
    sha256 = "1wfw46b647rkalwds6547ylzy353b3xlklhcl2xjgj2gihvi30mx";
  };
  pname = "gup";
  nativeBuildInputs = [ python3 which pylint ];
  buildInputs = [ python3 ];
  strictDeps = true;
  buildPhase = "make python";
  installPhase = ''
    mkdir $out
    cp -r python/bin $out/bin
  '';
  passthru.updateScript = [
    runtimeShell
    "-c"
    ''
      set -e
      echo
      cd ${toString ./.}
      ${nix-update-source}/bin/nix-update-source \
        --prompt version \
        --replace-attr version \
        --set owner timbertson \
        --set repo gup \
        --set type fetchFromGitHub \
        --set rev 'version-{version}' \
        --modify-nix default.nix
    ''
  ];
  meta = {
    inherit (src.meta) homepage;
    description = "Better make, inspired by djb's redo";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.timbertson ];
    platforms = lib.platforms.all;
  };
}
