{ stdenv, bundlerEnv, ruby, bundlerUpdateScript, makeWrapper }:

let
  pname = "fastlane";
  version = (import ./gemset.nix).fastlane.version;
  env = bundlerEnv {
    name = "${pname}-${version}-gems";
    inherit pname ruby;
    gemdir = ./.;
  };
in stdenv.mkDerivation rec {
  inherit pname version;

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/fastlane $out/bin/fastlane \
     --set FASTLANE_SKIP_UPDATE_CHECK 1
  '';

  passthru.updateScript = bundlerUpdateScript "fastlane";

  meta = with stdenv.lib; {
    description     = "A tool to automate building and releasing iOS and Android apps";
    longDescription = "fastlane is a tool for iOS and Android developers to automate tedious tasks like generating screenshots, dealing with provisioning profiles, and releasing your application.";
    homepage        = https://github.com/fastlane/fastlane;
    license         = licenses.mit;
    maintainers     = with maintainers; [
      peterromfeldhk
      nicknovitski
    ];
  };
}
