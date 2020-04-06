{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "richgo";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "kyoh86";
    repo = "richgo";
    rev = "v${version}";
    sha256 = "07ipa54c4mzm6yizgvkm6x5yim1xgv3f0xdxg35qziacdfcwd6m4";
  };

  modSha256 = "12wbjfqy6qnapm3f2pz1ci1gvc0y8kzr8c99kihyh1jv9r3zy1wz";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Enrich `go test` outputs with text decorations.";
    homepage = https://github.com/kyoh86/richgo;
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
