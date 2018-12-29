{ stdenv, fetchFromGitHub, nix-update-source, lib, python, which, pychecker ? null }:
stdenv.mkDerivation rec {
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "gup";
    rev = "version-0.7.0";
    sha256 = "1pwnmlq2pgkkln9sgz4wlb9dqlqw83bkf105qljnlvggc21zm3pv";
  };
  name = "gup-${version}";
  buildInputs = lib.remove null [ python which pychecker ];
  SKIP_PYCHECKER = pychecker == null;
  buildPhase = "make python";
  installPhase = ''
    mkdir $out
    cp -r python/bin $out/bin
  '';
  passthru.updateScript = ''
    #!${stdenv.shell}
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
  '';
  meta = {
    inherit (src.meta) homepage;
    description = "A better make, inspired by djb's redo";
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ stdenv.lib.maintainers.timbertson ];
    platforms = stdenv.lib.platforms.all;
  };
}
