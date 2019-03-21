{ stdenv, rustPlatform, fetchFromGitHub, CoreServices, CoreFoundation }:

rustPlatform.buildRustPackage rec {
  name = "watchexec-${version}";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    rev = version;
    sha256 = "0azfnqx5v1shsd7jdxzn41awh9dbjykv8h1isrambc86ygr1c1cy";
  };

  cargoSha256 = "1xlcfr2q2pw47sav9iryjva7w9chv90g18hszq8s0q0w71sccv6j";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  # FIXME: Use impure version of CoreFoundation because of missing symbols.
  #   Undefined symbols for architecture x86_64: "_CFURLResourceIsReachable"
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS="-F${CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS"
  '';

  meta = with stdenv.lib; {
    description = "Executes commands in response to file modifications";
    homepage = https://github.com/watchexec/watchexec;
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
