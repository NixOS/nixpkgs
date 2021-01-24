{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "swego";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "Swego";
    rev = "v${version}";
    sha256 = "14qww4ndvrxmrgkggr8hyvfpz2v7fw0vq6s8715mxa28f8pfi78b";
  };

  vendorSha256 = "068drahh0aysrm8cr5pgik27jqyk28bsx5130mc2v3xd0xmk8yp1";

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
