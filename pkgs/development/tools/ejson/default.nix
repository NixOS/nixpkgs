{ lib, bundlerEnv, ruby, buildGoModule, fetchFromGitHub }:
let
  # needed for manpage generation
  gems = bundlerEnv {
    name = "ejson-gems";
    gemdir = ./.;
    inherit ruby;
  };
in
buildGoModule rec {
  pname = "ejson";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "ejson";
    rev = "v${version}";
    sha256 = "sha256-M2Gk+/l1tNlIAe1/fR1WLEOey+tjCUmMAujc76gmeZA=";
  };

  vendorHash = "sha256-9+x7HrbXRoS/7ZADWwhsbynQLr3SyCbcsp9QnSubov0=";

  nativeBuildInputs = [ gems ];

  ldflags = [ "-s" "-w" ];

  # set HOME, otherwise bundler will insert stuff in the manpages
  postBuild = ''
    HOME=$PWD make man SHELL=$SHELL
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -r build/man $out/share
  '';

  meta = with lib; {
    description = "Small library to manage encrypted secrets using asymmetric encryption";
    mainProgram = "ejson";
    license = licenses.mit;
    homepage = "https://github.com/Shopify/ejson";
    maintainers = [ maintainers.manveru ];
  };
}
