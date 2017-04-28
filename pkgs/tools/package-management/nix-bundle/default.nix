{ stdenv, lib, fetchFromGitHub, nix, makeWrapper, coreutils, gnutar, gzip, bzip2 }:

stdenv.mkDerivation rec {
  pname = "nix-bundle";
  name = "${pname}-${version}";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = pname;
    rev = "v${version}";
    sha256 = "15r77pchf4s4cdv4lvw2zw1yic78k8p0n2r954qq370vscw30yac";
  };

  # coreutils, gnutar is actually needed by nix for bootstrap
  buildInputs = [ nix coreutils makeWrapper gnutar gzip bzip2 ];

  binPath = lib.makeBinPath [ nix coreutils gnutar gzip bzip2 ];

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
