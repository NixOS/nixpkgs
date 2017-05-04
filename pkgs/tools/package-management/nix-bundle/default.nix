{ stdenv, lib, fetchFromGitHub, nix, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "nix-bundle";
  name = "${pname}-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = pname;
    rev = "v${version}";
    sha256 = "13730rfnqjv1m2mky2g0cq77yzp2j215zrvy3lhpiwgmh97vviih";
  };

  buildInputs = [ nix makeWrapper ];

  binPath = lib.makeBinPath [ nix ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/share/nix-bundle/nix-bundle.sh $out/bin/nix-bundle \
      --prefix PATH : ${binPath}
  '';

  meta = with lib; {
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.all;
    description = "Create bundles from Nixpkgs attributes";
    license = licenses.mit;
    homepage = https://github.com/matthewbauer/nix-bundle;
  };
}
