{ callPackage }:

let
  mkElectron = callPackage ./generic.nix { };
in
rec {
  electron-bin = electron_29-bin;

  electron_24-bin = mkElectron "24.8.6" {
    armv7l-linux = "8f46901667a904a62df7043991f20dc1c2a00370a42159976855458562cda8fc";
    aarch64-linux = "599e78a3a8127828ea3fa444927e7e51035dba9811ce0d81d59ad9b0bd02b4f6";
    x86_64-linux = "61e87bbd361da101c6a8363cc9c1f8b8b51db61b076cf495d3f4424303265a96";
    x86_64-darwin = "067ce05d628b44e1393369c506268915081ac9d96c0973d367262c71dcd91078";
    aarch64-darwin = "d9093e6928b2247336b3f0811e4f66c4ae50a719ec9399c393ac9556c8e56cee";
    headers = "009p1ffh2cyn98fcmprrjzq79jysp7h565v4f54wvjxjsq2nkr97";
  };

  electron_27-bin = mkElectron "27.3.11" {
    armv7l-linux = "012127a3edf79e0e4623a08e853286e1cba512438a0414b1ab19b75d929c1cf2";
    aarch64-linux = "ddbfcd5e04450178ca4e3113f776893454822af6757761adc792692f7978e0df";
    x86_64-linux = "e3a6f55e54e7a623bba1a15016541248408eef5a19ab82a59d19c807aab14563";
    x86_64-darwin = "357e70a1c8848d4ac7655346bec98dd18a7c0cee82452a7edf76142017779049";
    aarch64-darwin = "a687b199fcb9890f43af90ac8a4d19dc7b15522394de89e42abd5f5c6b735804";
    headers = "0vrjdvqllfyz09sw2y078mds1di219hnmska8bw8ni7j35wxr2br";
  };

  electron_28-bin = mkElectron "28.3.1" {
    armv7l-linux = "2e22fbab2376a9bbeb8cbdd7d9bb3ca69fda6adeafa2b22ffb67157fcfcdb6ff";
    aarch64-linux = "3e46c3076041386213f7b9ebc12335889fbad5822ffc306cf7514abb88de8512";
    x86_64-linux = "e3be93e1a15d61f72e074aee021e12f20465b81f51b8c1170bd9072d7d695c3a";
    x86_64-darwin = "bd8a220fd906625ad4a8edf92e80e8eff89d51f40c22168e05090daa7c12bd66";
    aarch64-darwin = "53fc040cd09e955e013254f784cf51712029ded4a574559cf5fa19c9a911d75d";
    headers = "07iv5fh0yxv17c1akb2j4ab5xhv29d9zsgi6dm2r0n4pnf72wxwr";
  };

  electron_29-bin = mkElectron "29.3.0" {
    armv7l-linux = "51a8b2d67ae58b01919d6eb9e8eef255cd4bb3475b3acaf58ed1b8dc2448f206";
    aarch64-linux = "bd74743eb03a77f40b65739b9ca751af264c6f428e16728d7e0332a4c94789a9";
    x86_64-linux = "7274fe2bbb2e3b71f8fc084921e22d10e529220d380a354827b274f9567261da";
    x86_64-darwin = "88873a315ddd2a70b82e83f2cb7495c0d9d7c7fb5c9ad14fcfee16af4ab89d5e";
    aarch64-darwin = "b3145bbd45007918c2365b1df59a35b4d0636222cd43eea4803580de36b9a17d";
    headers = "1smvjlgdp3ailmh0fvxj96p7cnvls19w7kdwn62v1s3xpl84b915";
  };
}
