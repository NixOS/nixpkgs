{ stdenv, rustPlatform, fetchFromGitHub, CoreServices, CoreFoundation }:

rustPlatform.buildRustPackage rec {
  name = "watchexec-${version}";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    rev = version;
    sha256 = "0zp5s2dy5zbar0virvy1izjpvvgwbz7rvjmcy6bph6rb5c4bhm70";
  };

  cargoSha256 = "1li84kq9myaw0zwx69y72f3lx01s7i9p8yays4rwvl1ymr614y1l";

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
