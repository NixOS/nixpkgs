{ lib, callPackage, buildGoModule, fetchFromGitHub, makeWrapper, gnupg }:
buildGoModule rec {
  pname = "browserpass";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "browserpass";
    repo = "browserpass-native";
    rev = version;
    sha256 = "0q3bsla07zjl6i69nj1axbkg2ia89pvh0jg6nlqgbm2kpzzbn0pz";
  };

  nativeBuildInputs = [ makeWrapper ];

  modSha256 = "13yw7idgw8l48yvm4jjha0kbx6q22m2zp13y006mikavynqsr5kj";

  postPatch = ''
    # Because this Makefile will be installed to be used by the user, patch
    # variables to be valid by default
    substituteInPlace Makefile \
      --replace "PREFIX ?= /usr" ""
    sed -i -e 's/SED :=.*/SED := sed/' Makefile
    sed -i -e 's/INSTALL :=.*/INSTALL := install/' Makefile
  '';

  DESTDIR = placeholder "out";

  postConfigure = ''
    make configure
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install

    wrapProgram $out/bin/browserpass \
      --suffix PATH : ${lib.makeBinPath [ gnupg ]}

    # This path is used by our firefox wrapper for finding native messaging hosts
    mkdir -p $out/lib/mozilla/native-messaging-hosts
    ln -s $out/lib/browserpass/hosts/firefox/*.json $out/lib/mozilla/native-messaging-hosts
  '';

  meta = with lib; {
    description = "Browserpass native client app";
    homepage = https://github.com/browserpass/browserpass-native;
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ rvolosatovs infinisil ];
  };
}
