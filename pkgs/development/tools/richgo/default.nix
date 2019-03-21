{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "richgo-${version}";
  version = "0.2.8";
  goPackagePath = "github.com/kyoh86/richgo";

  src = fetchFromGitHub {
    owner = "kyoh86";
    repo = "richgo";
    rev = "v${version}";
    sha256 = "0kbwl3a2gima23zmahk0jxp7wga91bs927a1rp5xl889ikng1n4j";
  };

  meta = with stdenv.lib; {
    description = "Enrich `go test` outputs with text decorations.";
    homepage = https://github.com/kyoh86/richgo;
    license = licenses.unlicense; # NOTE: The project switched to MIT in https://git.io/fA1ik
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
