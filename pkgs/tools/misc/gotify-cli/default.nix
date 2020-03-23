{ buildGoModule, fetchFromGitHub, stdenv, Security }:

buildGoModule rec {
  pname = "gotify-cli";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${version}";
    sha256 = "131gs6xzfggnrzq5jgyky23zvcmhx3q3hd17xvqxd02s2i9x1mg4";
  };

  modSha256 = "1lrsg33zd7m24za2gv407hz02n3lmz9qljfk82whlj44hx7kim1z";

  postInstall = ''
    mv $out/bin/cli $out/bin/gotify
  '';

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = https://github.com/gotify/cli;
    description = "A command line interface for pushing messages to gotify/server.";
    maintainers = with maintainers; [ ma27 ];
  };
}
