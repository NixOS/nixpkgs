{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "parinfer-rust-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "eraserhd";
    repo = "parinfer-rust";
    rev = "v${version}";
    sha256 = "0w7fcg33k8k16q8wzax44ck8csa2dr7bmwcz1g57dz33vhxi8ajc";
  };

  cargoSha256 = "17fkzpvfaxixllr9nxx7dnpqxkiighggryxf30j3lafghyrx987f";

  postInstall = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp rc/parinfer.kak $out/share/kak/autoload/plugins/
  '';

  meta = with stdenv.lib; {
    description = "Infer parentheses for Clojure, Lisp, and Scheme.";
    homepage = "https://github.com/eraserhd/parinfer-rust";
    license = licenses.isc;
    maintainers = with maintainers; [ eraserhd ];
    platforms = platforms.all;
  };
}
