{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "echoip-${version}";
  version = "unstable-2018-11-20";

  goPackagePath = "github.com/mpolden/echoip";

  src = fetchFromGitHub {
    owner = "mpolden";
    repo = "echoip";
    rev = "4bfaf671b9f75a7b2b37543b2991401cbf57f1f0";
    sha256 = "0n5d9i8cc5lqgy5apqd3zhyl3h1xjacf612z8xpvbm75jnllcvxy";
  };

  goDeps = ./deps.nix;

  outputs = [ "bin" "out" ];

  postInstall = ''
    mkdir -p $out
    cp $src/index.html $out/index.html
  '';

  meta = with lib; {
    homepage = https://github.com/mpolden/echoip;
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
