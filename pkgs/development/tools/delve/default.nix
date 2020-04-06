{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "delve";
  version = "1.2.0";

  goPackagePath = "github.com/go-delve/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    sha256 = "1xz1xm0lb1arwm3w2ydq5y5xglq60fc0q46x9xndr3i9j0rm8bxh";
  };

  meta = with stdenv.lib; {
    description = "debugger for the Go programming language";
    homepage = https://github.com/derekparker/delve;
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
