{
  bzip2,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nix,
  perl,
  perlPackages,
  stdenv,
}:

let rev = "7e09caa2a7a435aeb2cd5446aa590d6f9ae1699d"; in

stdenv.mkDerivation rec {
  name = "nix-serve-0.2-${lib.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-serve";
    inherit rev;
    sha256 = "0mjzsiknln3isdri9004wwjjjpak5fj8ncizyncf5jv7g4m4q1pj";
  };

  buildInputs = [ makeWrapper ];

  propagatedBuildInputs = [
    nix
    perl
    perlPackages.DBDSQLite
    perlPackages.DBI
    perlPackages.Plack
    perlPackages.Starman
  ];

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/libexec/nix-serve
    cp nix-serve.psgi $out/libexec/nix-serve/nix-serve.psgi

    mkdir -p $out/bin
    cat > $out/bin/nix-serve <<EOF
    #! ${stdenv.shell}
    exec ${perlPackages.Starman}/bin/starman $out/libexec/nix-serve/nix-serve.psgi "\$@"
    EOF
    chmod +x $out/bin/nix-serve

    wrapProgram $out/bin/nix-serve \
      --prefix PATH : "${nix.out}/bin:${bzip2.out}/bin" \
      --prefix PERL5LIB : $PERL5LIB
    '';

  meta = {
    homepage = https://github.com/edolstra/nix-serve;
    description = "A utility for sharing a Nix store as a binary cache";
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.gpl3;
    platforms = nix.meta.platforms;
  };
}
