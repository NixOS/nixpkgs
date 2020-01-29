{ stdenv, rustPlatform, fetchFromGitHub, llvmPackages }:

rustPlatform.buildRustPackage rec {
  pname = "parinfer-rust";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "eraserhd";
    repo = "parinfer-rust";
    rev = "v${version}";
    sha256 = "1k2kr1zlxx3w3kwb634kngzx8vl5iif1yr6zk2xh46gjwqb3223l";
  };

  cargoSha256 = "0i5wy15w985nxwl4b6rzb06hchzjwph6ygzjkkmigm9diw9jcycn";

  buildInputs = [ llvmPackages.libclang llvmPackages.clang ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  postInstall = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp rc/parinfer.kak $out/share/kak/autoload/plugins/

    rtpPath=$out/share/vim-plugins/parinfer-rust
    mkdir -p $rtpPath/plugin
    sed "s,let s:libdir = .*,let s:libdir = '${placeholder "out"}/lib'," \
      plugin/parinfer.vim >$rtpPath/plugin/parinfer.vim
  '';

  meta = with stdenv.lib; {
    description = "Infer parentheses for Clojure, Lisp, and Scheme.";
    homepage = "https://github.com/eraserhd/parinfer-rust";
    license = licenses.isc;
    maintainers = with maintainers; [ eraserhd ];
    platforms = platforms.all;
  };
}
