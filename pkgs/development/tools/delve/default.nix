{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "delve";
  version = "1.6.0";

  goPackagePath = "github.com/go-delve/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    sha256 = "sha256-krNCS5GaEMuwQ9XS8w0myL+xZX6goNNNBgUiRVoZPIU=";
  };

  meta = with lib; {
    description = "debugger for the Go programming language";
    homepage = "https://github.com/derekparker/delve";
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
