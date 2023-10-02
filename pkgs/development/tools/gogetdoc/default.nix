{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gogetdoc-unstable";
  version = "2019-02-28";
  rev = "b37376c5da6aeb900611837098f40f81972e63e4";

  vendorHash = null;

  doCheck = false;

  src = fetchFromGitHub {
    inherit rev;

    owner = "zmb3";
    repo = "gogetdoc";
    sha256 = "1v74zd0x2xh10603p8raazssacv3y0x0lr9apkpsdk0bfp5jj0lr";
  };

  meta = with lib; {
    description = "Gets documentation for items in Go source code";
    homepage = "https://github.com/zmb3/gogetdoc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
