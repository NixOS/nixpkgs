{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "0zifha3mj7386q2accrdmd8qniingadxz1v8vg4mciwi723msr44";
  };

  modSha256 = "10zkk4zqla5yqs5sq2qc7x1vhadfyd1l7s29xyjmg4grs8iimk2j";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/gotestyourself/gotestsum";
    description = "A human friendly `go test` runner";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}
