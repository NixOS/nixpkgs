{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "2.6.8";

  subPackages = [ "." ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "sha256-evvnIM8sd/eHpI2FYOlgjvGn8awTVc1f5QDIYAvhqmk=";
  };

  vendorSha256 = null;

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
