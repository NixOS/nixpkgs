{ lib, stdenv, fetchurl, docutils, libev, openssl, pkg-config, nixosTests }:
stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.8.0";
=======
  version = "1.7.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "hitch";

  src = fetchurl {
    url = "https://hitch-tls.org/source/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-38mUhLx//qJ6MWnoTWwheYjtpHsgirLlUk3Cpd0Vj04=";
=======
    sha256 = "sha256-Ghv0lV13W3GNwxyJoaBRdlMLDKhW+V7kKivHoj8ol4c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ docutils libev openssl ];

  outputs = [ "out" "doc" "man" ];

  passthru.tests.hitch = nixosTests.hitch;

  meta = with lib; {
    description = "Libev-based high performance SSL/TLS proxy by Varnish Software";
    homepage = "https://hitch-tls.org/";
    license = licenses.bsd2;
    maintainers = [ maintainers.jflanglois ];
    platforms = platforms.linux;
  };
}
