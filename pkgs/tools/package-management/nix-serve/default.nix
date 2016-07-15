{ stdenv, fetchFromGitHub,
  bzip2, nix, perl, perlPackages,
}:

with stdenv.lib;

let
  rev = "7e09caa2a7a435aeb2cd5446aa590d6f9ae1699d";
  sha256 = "0mjzsiknln3isdri9004wwjjjpak5fj8ncizyncf5jv7g4m4q1pj";
in

stdenv.mkDerivation rec {
  name = "nix-serve-0.2-${substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-serve";
    inherit rev sha256;
  };

  buildInputs = [ bzip2 perl nix ]
    ++ (with perlPackages; [ DBI DBDSQLite Plack Starman ]);

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/libexec/nix-serve
    cp nix-serve.psgi $out/libexec/nix-serve/nix-serve.psgi

    mkdir -p $out/bin
    cat > $out/bin/nix-serve <<EOF
    #! ${stdenv.shell}
    PATH=${makeBinPath [ bzip2 nix ]}:\$PATH PERL5LIB=$PERL5LIB exec ${perlPackages.Starman}/bin/starman $out/libexec/nix-serve/nix-serve.psgi "\$@"
    EOF
    chmod +x $out/bin/nix-serve
  '';

  meta = {
    homepage = https://github.com/edolstra/nix-serve;
    description = "A utility for sharing a Nix store as a binary cache";
    maintainers = [ maintainers.eelco ];
    license = licenses.gpl3;
    platforms = nix.meta.platforms;
  };
}
