{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "swego";
  version = "0.97";

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "Swego";
    rev = "v${version}";
    sha256 = "sha256-T4xkjNdOSD0kHLVfwUz1PrFokLmnbzcj/pbV36W+2ZQ=";
  };

  vendorSha256 = "sha256-GiYJfykcBvIoJ0zvdtT3P+iHmBgBWIeOTaniFysAPHs=";

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
