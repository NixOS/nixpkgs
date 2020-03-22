{ buildGoModule, fetchFromGitHub, stdenv, Security }:

buildGoModule rec {
  pname = "grpcui";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dcah6bamjqyp9354qrd1cykdr5k5l93hh7qcy5b4nkag9531gl0";
  };

  modSha256 = "1yq8484cjxad72nqsrim3zppr8hmn7dc6f8rgkw8fg952lqy5jjb";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "An interactive web UI for gRPC, along the lines of postman";
    homepage = "https://github.com/fullstorydev/grpcui";
    license = licenses.mit;
    maintainers = with maintainers; [ pradyuman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
