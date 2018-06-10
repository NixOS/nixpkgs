{ stdenv, fetchFromGitHub, fetchpatch,
  bzip2, nix, perl, perlPackages,
}:

with stdenv.lib;

let
  rev = "e4675e38ab54942e351c7686e40fabec822120b9";
  sha256 = "1wm24p6pkxl1d7hrvf4ph6mwzawvqi22c60z9xzndn5xfyr4v0yr";
in

stdenv.mkDerivation rec {
  name = "nix-serve-0.2-${substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-serve";
    inherit rev sha256;
  };

  buildInputs = [ bzip2 perl nix nix.perl-bindings ]
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
