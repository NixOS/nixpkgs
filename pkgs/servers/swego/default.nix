{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "swego";
  version = "0.98";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "Swego";
    rev = "v${version}";
    sha256 = "sha256-fS1mrB4379hnnkLMkpKqV2QB680t5T0QEqsvqOp9pzY=";
  };

  vendorSha256 = "sha256-N4HDngQFNCzQ74W52R0khetN6+J7npvBC/bYZBAgLB4=";

  postInstall = ''
    mv $out/bin/src $out/bin/$pname
  '';

  meta = with lib; {
    description = "Simple Webserver in Golang";
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
  };
}
