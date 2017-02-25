{ stdenv, fetchFromGitHub, rustPlatform, llvmPackages, v8 }:

with rustPlatform;

buildRustPackage rec {
  name = "rq-${version}";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "dflemstr";
    repo = "rq";
    rev = "v${version}";
    sha256 = "051k7ls2mbjf584crayd654wm8m7gk3b7s73j97f9l8sbppdhpcq";
  };

  serde_json = fetchFromGitHub {
    owner = "serde-rs";
    repo = "json";
    rev = "0c05059e4533368020bd356bd708c38286810a7d";
    sha256 = "0924ngqbsif2vmmpgn8l2gg4bzms0z0i7yng0zx6sdv0x836lw43";
  };

  v8_rs = fetchFromGitHub {
    owner = "dflemstr";
    repo = "v8-rs";
    rev = "0772be5b2e84842a2d434963702bc2995aeda90b";
    sha256 = "0h2n431rp6nqpip7dy7xpckkvcr19aq7l1f3x3wlrj02xi4c8mad";
  };

  cargoDepsHook = ''
    # use non-git dependencies
    (cd $sourceRoot && patch -p1 <<EOF)
    diff -u a/Cargo.toml b/Cargo.toml
    --- a/Cargo.toml	2016-12-03 21:29:31.615019030 +0100
    +++ b/Cargo.toml	2016-12-03 21:30:12.188170359 +0100
    @@ -40,15 +40,16 @@
     version = "*"
     
     [dependencies.serde_json]
    -branch = "v0.9.0"
    -git = "https://github.com/serde-rs/json.git"
    +path = "${serde_json}/json"
    +version = "*"
     
     [dependencies.toml]
     features = ["serde"]
     version = "*"
     
     [dependencies.v8]
    -git = "https://github.com/dflemstr/v8-rs.git"
    +path = "${v8_rs}"
    +version = "*"
     
     [features]
     shared = ["v8/shared"]
    EOF
  '';

  depsSha256 = "1pci9iwf4y574q32b05gbc490iqw5i7shvqgb1gblchrihvlkddq";

  buildInputs = [ llvmPackages.clang-unwrapped v8 ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.clang-unwrapped}/lib"
    export V8_SOURCE="${v8}"
  '';

  meta = with stdenv.lib; {
    description = "A tool for doing record analysis and transformation";
    homepage = https://github.com/dflemstr/rq ;
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.aristid ];
    platforms = platforms.all;
    broken = true;
  };
}
