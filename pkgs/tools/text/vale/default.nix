{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "2.5.0";

  subPackages = [ "." ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "0favaijdddm0lajlv0a277mg286jh12kwfndf98zdp0vfq9lv00d";
  };

  vendorSha256 = null;

  doCheck = false;

  postInstall = ''
    mkdir -p $data/share/vale
    cp -r styles $data/share/vale
  '';

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://errata-ai.gitbook.io/vale/";
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
