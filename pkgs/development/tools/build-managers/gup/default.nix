{ stdenv, fetchFromGitHub, nix-update-source, lib, python3
, which, runtimeShell, pychecker ? null }:
stdenv.mkDerivation rec {
  version = "0.8.4";
  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gup";
    rev = "version-${version}";
    sha256 = "0b8q9mrr7b9silwc4mp733j1z18g4lp6ppdi8p2rxzgb2fb4bkvp";
  };
  pname = "gup";
  nativeBuildInputs = [ python3 which pychecker ];
  buildInputs = [ python3 ];
  strictDeps = true;
  SKIP_PYCHECKER = pychecker == null;
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
    description = "A better make, inspired by djb's redo";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.timbertson ];
    platforms = lib.platforms.all;
  };
}
