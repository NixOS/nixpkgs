{ lib, buildGoModule, fetchFromGitHub, makeWrapper, gnupg }:
buildGoModule rec {
  pname = "browserpass";
  version = "3.0.10";

  src = fetchFromGitHub {
    owner = "browserpass";
    repo = "browserpass-native";
    rev = version;
    sha256 = "8eAwUwcRTnhVDkQc3HsvTP0TqC4LfVrUelxdbJxe9t0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorSha256 = "gWXcYyIp86b/Pn6vj7qBj/VZS9rTr4weVw0YWmg+36c=";

  doCheck = false;

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
    homepage = "https://github.com/browserpass/browserpass-native";
    license = licenses.isc;
    maintainers = with maintainers; [ rvolosatovs infinisil ];
  };
}
