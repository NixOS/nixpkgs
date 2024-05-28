{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "swego";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "Swego";
    rev = "refs/tags/v${version}";
    hash = "sha256-O/wczHyaMev0CpAXoDxiN7TtHDsthG+jaH31SPMEB34=";
  };

  vendorHash = "sha256-mJWJdwbZq042//hM3WWp2rnLC1GebckUnsIopbF858Q=";

  postInstall = ''
    mv $out/bin/src $out/bin/$pname
  '';

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Simple Webserver";
    longDescription = ''
      Swiss army knife Webserver in Golang. Similar to the Python
      SimpleHTTPServer but with many features.
    '';
    homepage = "https://github.com/nodauf/Swego";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
    # darwin crashes with:
    # src/controllers/parsingArgs.go:130:4: undefined: PrintEmbeddedFiles
    broken = stdenv.isDarwin;
    mainProgram = "swego";
  };
}
