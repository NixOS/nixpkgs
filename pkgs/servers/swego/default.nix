{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "swego";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "Swego";
    rev = "v${version}";
    sha256 = "sha256-Wt+2spZfgBWzZEQP+SiDYI5DdLKrwFMgYT1ukbF4x0I=";
  };

  vendorSha256 = "sha256-EPcyhnTis7g0uVl+cJdG7iMbisjh7iuMhpzM/SSOeFI=";

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
