{ stdenv, lib, fetchFromGitHub, nix, makeWrapper, coreutils, gnutar, gzip, bzip2 }:

stdenv.mkDerivation rec {
  pname = "nix-bundle";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = pname;
    rev = "v${version}";
    sha256 = "084m9hqm1nhwln2sbg8ck2v2dprvpldxxqmd1r8fcj3dmn4bysz0";
  };

  # coreutils, gnutar is actually needed by nix for bootstrap
  buildInputs = [ nix coreutils makeWrapper gnutar gzip bzip2 ];

  binPath = lib.makeBinPath [ nix coreutils gnutar gzip bzip2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/share/nix-bundle/nix-bundle.sh $out/bin/nix-bundle \
      --prefix PATH : ${binPath}
    cp $out/share/nix-bundle/nix-run.sh $out/bin/nix-run
  '';

  meta = with lib; {
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.all;
    description = "Create bundles from Nixpkgs attributes";
    license = licenses.mit;
    homepage = https://github.com/matthewbauer/nix-bundle;
  };
}
