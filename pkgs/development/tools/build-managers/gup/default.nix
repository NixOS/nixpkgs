{ stdenv, fetchFromGitHub, nix-update-source, lib, python3
, which, runtimeShell, pychecker ? null }:
stdenv.mkDerivation rec {
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gup";
    rev = "version-${version}";
    sha256 = "1zjd76jyb5zc9w3l368723bjmxjl05s096g8ipwncfks1p9hdgf3";
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
