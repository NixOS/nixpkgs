{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, gnupg
, makeWrapper
<<<<<<< HEAD
, autoPatchelfHook
, testers
, browserpass
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "browserpass";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "browserpass";
    repo = "browserpass-native";
    rev = version;
    sha256 = "sha256-UZzOPRRiCUIG7uSSp9AEPMDN/+4cgyK47RhrI8oUx8U=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];
=======
  nativeBuildInputs = [ makeWrapper ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  vendorHash = "sha256-CjuH4ANP2bJDeA+o+1j+obbtk5/NVLet/OFS3Rms4r0=";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postPatch = ''
    # Because this Makefile will be installed to be used by the user, patch
    # variables to be valid by default
    substituteInPlace Makefile \
      --replace "PREFIX ?= /usr" ""
    sed -i -e 's/SED =.*/SED = sed/' Makefile
    sed -i -e 's/INSTALL =.*/INSTALL = install/' Makefile
  '';

  DESTDIR = placeholder "out";

  postConfigure = ''
    make configure
  '';

  buildPhase = ''
    make browserpass
  '';

  checkTarget = "test";

  installPhase = ''
    make install

    wrapProgram $out/bin/browserpass \
      --suffix PATH : ${lib.makeBinPath [ gnupg ]}

    # This path is used by our firefox wrapper for finding native messaging hosts
    mkdir -p $out/lib/mozilla/native-messaging-hosts
    ln -s $out/lib/browserpass/hosts/firefox/*.json $out/lib/mozilla/native-messaging-hosts
  '';

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion {
    package = browserpass;
    command = "browserpass --version";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Browserpass native client app";
    homepage = "https://github.com/browserpass/browserpass-native";
    license = licenses.isc;
    maintainers = with maintainers; [ rvolosatovs infinisil ];
  };
}
