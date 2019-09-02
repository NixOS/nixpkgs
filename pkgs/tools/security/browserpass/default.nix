{ lib, callPackage, buildGoPackage, fetchFromGitHub, makeWrapper, gnupg }:
let
  # For backwards compatibility with v2 of the browser extension, we embed v2
  # of the native host in v3. Because the extension will auto-update when it
  # is released, this code can be removed from that point on.
  # Don't forget to remove v2 references down below and the v2 files in this
  # folder
  v2 = callPackage ./2.nix {};
in buildGoPackage rec {
  pname = "browserpass";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "browserpass";
    repo = "browserpass-native";
    rev = version;
    sha256 = "0q3bsla07zjl6i69nj1axbkg2ia89pvh0jg6nlqgbm2kpzzbn0pz";
  };

  nativeBuildInputs = [ makeWrapper ];

  goPackagePath = "github.com/browserpass/browserpass-native";
  goDeps = ./deps.nix;

  postPatch = ''
    # Because this Makefile will be installed to be used by the user, patch
    # variables to be valid by default
    substituteInPlace Makefile \
      --replace "PREFIX ?= /usr" ""
    sed -i -e 's/SED :=.*/SED := sed/' Makefile
    sed -i -e 's/INSTALL :=.*/INSTALL := install/' Makefile
  '';

  DESTDIR = placeholder "bin";

  postConfigure = ''
    cd "go/src/$goPackagePath"
    make configure
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install

    wrapProgram $bin/bin/browserpass \
      --suffix PATH : ${lib.makeBinPath [ gnupg ]}

    # This path is used by our firefox wrapper for finding native messaging hosts
    mkdir -p $bin/lib/mozilla/native-messaging-hosts
    ln -s $bin/lib/browserpass/hosts/firefox/*.json $bin/lib/mozilla/native-messaging-hosts

    # These can be removed too, see comment up top
    ln -s ${lib.getBin v2}/etc $bin/etc
    ln -s ${lib.getBin v2}/lib/mozilla/native-messaging-hosts/* $bin/lib/mozilla/native-messaging-hosts
  '';

  meta = with lib; {
    description = "Browserpass native client app";
    homepage = https://github.com/browserpass/browserpass-native;
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ rvolosatovs infinisil ];
  };
}
