{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "1jq529m788yp3b6j4dhxgcw7qm1lyxx1ir2vwr41vp7gh17fmwar";
  };

  vendorSha256 = "1injixhllv41glb3yz276gjrkiwwkfimrhb367d2pvjpzqmhplan";

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
