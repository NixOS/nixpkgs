{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cshatag";
  version = "2019-12-03";

  goPackagePath = "github.com/rfjakob/cshatag";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "b169f0a9dd35a7381774eb176d4badf64d403560";
    sha256 = "16kam3w75avh8khkk6jfdnxwggz2pw6ccv6v7d064j0fbb9y8x0v";
  };

  makeFlags = [ "PREFIX=$(out)" "GITVERSION=${version}" ];

  postInstall = ''
    # Install man page
    cd go/src/${goPackagePath}
    make install $makeFlags
  '';

  meta = with lib; {
    description = "A tool to detect silent data corruption";
    homepage = "https://github.com/rfjakob/cshatag";
    license = licenses.mit;
    platforms = platforms.linux;
  };

}
