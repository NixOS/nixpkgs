{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "2.3.4";

  subPackages = [ "." ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner  = "errata-ai";
    repo   = "vale";
    rev    = "v${version}";
    sha256 = "0vk7kk2a2891vm46lss8q2893n2zdirlicac2f3xfkrbb5lhkicd";
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
