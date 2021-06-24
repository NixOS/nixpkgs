{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "echoip";
  version = "unstable-2019-07-12";

  src = fetchFromGitHub {
    owner = "mpolden";
    repo = "echoip";
    rev = "fb5fac92d2173c2a5b07ed4ecc7b5fefe8484ed2";
    sha256 = "17gkh1qfxasvxy25lmjdwk5fsjkcp7lmw9si3xzf01m7qnj5zi4b";
  };

  vendorSha256 = "0vvs717pl5gzggxpbn2vkyxmpiw5zjdfnpbh8i81xidbqvlnm22h";

  doCheck = false;

  outputs = [ "out" "index" ];

  postInstall = ''
    mkdir -p $index
    cp $src/index.html $index/index.html
  '';

  meta = with lib; {
    homepage = "https://github.com/mpolden/echoip";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
