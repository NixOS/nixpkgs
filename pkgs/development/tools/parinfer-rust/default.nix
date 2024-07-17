{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvmPackages,
}:

rustPlatform.buildRustPackage rec {
  pname = "parinfer-rust";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "eraserhd";
    repo = "parinfer-rust";
    rev = "v${version}";
    sha256 = "0hj5in5h7pj72m4ag80ing513fh65q8xlsf341qzm3vmxm3y3jgd";
  };

  cargoSha256 = "1lam4gwzcj6w0pyxf61l2cpbvvf5gmj2gwi8dangnhd60qhlnvrx";

  nativeBuildInputs = [
    llvmPackages.clang
    rustPlatform.bindgenHook
  ];

  postInstall = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp rc/parinfer.kak $out/share/kak/autoload/plugins/

    rtpPath=$out/plugin
    mkdir -p $rtpPath
    sed "s,let s:libdir = .*,let s:libdir = '${placeholder "out"}/lib'," \
      plugin/parinfer.vim > $rtpPath/parinfer.vim
  '';

  meta = with lib; {
    description = "Infer parentheses for Clojure, Lisp, and Scheme";
    mainProgram = "parinfer-rust";
    homepage = "https://github.com/eraserhd/parinfer-rust";
    license = licenses.isc;
    maintainers = with maintainers; [ eraserhd ];
  };
}
