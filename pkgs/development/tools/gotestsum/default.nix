{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "0w0s2qvwnb69s18gvkkbwsx9zh7yi8ksnnrfpl8az8sybk6m1iaz";
  };

  vendorSha256 = "09cifc69z1ashjw1mqgbi0gh90h2sypqyl0jswxxcqk89ibgy3am";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/gotestyourself/gotestsum";
    description = "A human friendly `go test` runner";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}
