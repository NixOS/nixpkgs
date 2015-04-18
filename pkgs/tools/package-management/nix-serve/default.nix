{ lib, stdenv, fetchFromGitHub, perl, nix, perlPackages }:

let rev = "4c24e3ffa7d267d67d87135e7ac4c9198e449cd3"; in

stdenv.mkDerivation rec {
  name = "nix-serve-0.1-${lib.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-serve";
    inherit rev;
    sha256 = "1c0ip4w00j86412l2qf0dwzjr9jzimiygbx82x15r46kr3cpk7kp";
  };

  buildInputs = [ perl nix perlPackages.Plack perlPackages.Starman ];

  buildPhase = "true";

  # FIXME: unfortunate cut&paste.
  installPhase =
    ''
      mkdir -p $out/libexec/nix-serve
      cp nix-serve.psgi $out/libexec/nix-serve/nix-serve.psgi

      mkdir -p $out/bin
      cat > $out/bin/nix-serve <<EOF
      #! ${stdenv.shell}
      PERL5LIB=$PERL5LIB exec ${perlPackages.Starman}/bin/starman $out/libexec/nix-serve/nix-serve.psgi "\$@"
      EOF
      chmod +x $out/bin/nix-serve
    '';

  meta = {
    homepage = https://github.com/edolstra/nix-serve;
    description = "A utility for sharing a Nix store as a binary cache";
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.gpl3;
    platforms = nix.meta.platforms;
  };
}
