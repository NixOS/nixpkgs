{ stdenv, fetchFromGitHub, rustPlatform, llvmPackages, v8 }:

with rustPlatform;

buildRustPackage rec {
  name = "rq-${version}";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "dflemstr";
    repo = "rq";
    rev = "v${version}";
    sha256 = "066f6sdy0vrp113wlg18q9p0clyrg9iqbj17ly0yn8dxr5iar002";
  };

  depsSha256 = "138h0q2a2gghfjpwfi11zw4rkipvmglb7srqz56ibbw2xliid2wl";

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
