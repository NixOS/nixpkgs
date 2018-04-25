{ pkgs, stdenv, fetchFromGitHub, mypy, python3 }:
let self = stdenv.mkDerivation rec {
  name = "nix-pin-${version}";
  version = "0.2.2";
  src = fetchFromGitHub {
    owner = "timbertson";
    repo = "nix-pin";
    rev = "version-0.2.2";
    sha256 = "1kw43kzy4m6lnnif51r2a8i4vcgr7d4vqb1c75p7pk2b9y3jwxsz";
  };
  buildInputs = [ python3 mypy ];
  buildPhase = ''
    mypy bin/*
  '';
  installPhase = ''
    mkdir "$out"
    cp -r bin share "$out"
  '';
  passthru =
    let
      defaults = import "${self}/share/nix/defaults.nix";
    in {
      api = { pinConfig ? defaults.pinConfig }:
        let impl = import "${self}/share/nix/api.nix" { inherit pkgs pinConfig; }; in
        { inherit (impl) augmentedPkgs pins callPackage; };
      updateScript = ''
        set -e
        echo
        cd ${toString ./.}
        ${pkgs.nix-update-source}/bin/nix-update-source \
          --prompt version \
          --replace-attr version \
          --set owner timbertson \
          --set repo nix-pin \
          --set type fetchFromGitHub \
          --set rev 'version-{version}' \
          --modify-nix default.nix
      '';
    };
  meta = with stdenv.lib; {
    homepage = "https://github.com/timbertson/nix-pin";
    description = "nixpkgs development utility";
    license = licenses.mit;
    maintainers = [ maintainers.timbertson ];
    platforms = platforms.all;
  };
}; in self
