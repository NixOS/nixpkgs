{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  rev = "27e692e6ec36d8f48be794f32553e1400c70dbf2";
  version = "git-2015-06-02";
  name = "stringer-${version}";
  goPackagePath = "golang.org/x/tools";

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "tools";
    sha256 = "0pk2yzn6glrj5fw57b2hsw4np34vns22d1lssha1vay6x39ykh8j";
  };

  subPackages = [ "cmd/stringer" ];

  dontInstallSrc = true;

  meta = with lib; {
    description = "Stringer is a tool for go to automate integer constant string methods";
    homepage = https://godoc.org/golang.org/x/tools/cmd/stringer;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jzellner ];
    platforms = platforms.unix;
  };
}
