{ buildGoPackage, stdenv, fetchFromGitHub }:

buildGoPackage rec {
  version = "2.0.0";
  name = "xurls-${version}";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    rev = "v${version}";
    sha256 = "1jdjwlp19r8cb7vycyrjmpwf8dz2fzrqphq4lkvy9x2v7x0kksx8";
  };

  goPackagePath = "mvdan.cc/xurls/v2";
  subPackages = [ "cmd/xurls" ];

  meta = with stdenv.lib; {
    description = "Extract urls from text";
    homepage = https://github.com/mvdan/xurls;
    maintainers = with maintainers; [ koral ndowens ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
