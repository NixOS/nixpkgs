{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "delve";
  version = "1.4.1";

  goPackagePath = "github.com/go-delve/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    sha256 = "007bc69r26w0sv6v9mbjdnmnkahpfk5998isx81ma7cinqdhi1cj";
  };

  meta = with stdenv.lib; {
    description = "debugger for the Go programming language";
    homepage = "https://github.com/derekparker/delve";
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
