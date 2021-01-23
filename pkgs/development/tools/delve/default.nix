{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "delve";
  version = "1.5.1";

  goPackagePath = "github.com/go-delve/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    sha256 = "10zvla2jqxqibxdk3zbnsxg63i0zcwcn9npvw3bbicwd2z4vvskk";
  };

  meta = with stdenv.lib; {
    description = "debugger for the Go programming language";
    homepage = "https://github.com/derekparker/delve";
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
