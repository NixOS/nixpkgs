{ lib, stdenv, fetchFromGitHub, libjpeg, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "jhead";
  version = "3.06.0.1";

  src = fetchFromGitHub {
    owner = "Matthias-Wandel";
    repo = "jhead";
    rev = version;
    sha256 = "0zgh36486cpcnf7xg6dwf7rhz2h4gpayqvdk8hmrx6y418b2pfyf";
  };

  patches = [
    # Just a spelling/whitespace change, but makes it easier to apply the rest.
    (fetchpatch {
      url = "https://github.com/Matthias-Wandel/jhead/commit/8384c6fd2ebfb8eb8bd96616343e73af0e575131.patch";
      sha256 = "sha256-f3FOIqgFr5QPAsBjvUVAOf1CAqw8pNAVx+pZZuMjq3c=";
      includes = [ "jhead.c" ];
    })
    (fetchpatch {
      url = "https://github.com/Matthias-Wandel/jhead/commit/63aff8e9bd8c970fedf87f0ec3a1f3368bf2421e.patch";
      sha256 = "sha256-jyhGdWuwd/eP5uuS8uLYiTJZJdxxLYdsvl0jnQC+Y5c=";
      includes = [ "jhead.c" ];
    })

    # Fixes around CVE-2022-41751
    (fetchpatch {
      url = "https://github.com/Matthias-Wandel/jhead/commit/6985da52c9ad4f5f6c247269cb5508fae34a971c.patch";
      sha256 = "sha256-8Uw0Udr9aZEMrD/0zS498MVw+rJqpFukvjb7FgzjgT4=";
    })
    (fetchpatch {
      url = "https://github.com/Matthias-Wandel/jhead/commit/3fe905cf674f8dbac8a89e58cee1b4850abf9530.patch";
      sha256 = "sha256-5995EV/pOktZc45c7fLl+oQqyutRDQJl3eNutR1JGJo=";
    })
    (fetchpatch {
      url = "https://github.com/joachim-reichel/jhead/commit/ec67262b8e5a4b05d8ad6898a09f1dc3fc032062.patch";
      sha256 = "sha256-a3KogIV45cRNthJSPygIRw1m2KBJZJSIGSWfsr7FWs4=";
    })
    (fetchpatch {
      url = "https://github.com/joachim-reichel/jhead/commit/65de38cb68747c6f8397608b56b58ce15271a1fe.patch";
      sha256 = "sha256-xf0d2hxW4rVZwffrYJVVFQ3cDMOcPoGbCdrrQKxf16M=";
    })
  ];

  buildInputs = [ libjpeg ];

  makeFlags = [ "CPPFLAGS=" "CFLAGS=-O3" "LDFLAGS=" ];

  installPhase = ''
    mkdir -p \
      $out/bin \
      $out/man/man1 \
      $out/share/doc/${pname}-${version}

    cp -v jhead $out/bin
    cp -v jhead.1 $out/man/man1
    cp -v *.txt $out/share/doc/${pname}-${version}
  '';

  meta = with lib; {
    homepage = "http://www.sentex.net/~mwandel/jhead/";
    description = "Exif Jpeg header manipulation tool";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
