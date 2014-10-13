{ stdenv, eggDerivation, fetchurl, chickenEggs }:

# Note: This mostly reimplements the default.nix already contained in
# the tarball. Is there a nicer way than duplicating code?

eggDerivation {
  src = fetchurl {
    url = "https://github.com/the-kenny/egg2nix/archive/0.1.tar.gz";
    sha256 = "0x1vg70rwvd4dbgp8wynlff36cnq1h9ncpag0xgn5jq0miqfr57j";
  };

  name = "egg2nix-0.1";
  buildInputs = with chickenEggs; [
    versions matchable http-client
  ];

  installPhase = ''
    mkdir -p $out/bin/
    mv egg2nix.scm $out/bin/egg2nix
    chmod +x $out/bin/egg2nix

    runHook postInstall #important - wraps the stuff in $out/bin/
  '';

  meta = {
    description = "Generate nix-expression from Chicken Scheme eggs";
    homepage = https://github.com/the-kenny/egg2nix;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
  };
}
