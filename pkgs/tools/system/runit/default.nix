{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "runit-${version}";
  version = "2.1.2";

  src = fetchurl {
    url = "http://smarden.org/runit/${name}.tar.gz";
    sha256 = "065s8w62r6chjjs6m9hapcagy33m75nlnxb69vg0f4ngn061dl3g";
  };

  phases = [ "unpackPhase" "patchPhase" "buildPhase" "checkPhase" "installPhase" ];

  patches = [ ./Makefile.patch ];

  postPatch = ''
    cd ${name}
    sed -i 's,-static,,g' src/Makefile
  '';

  buildPhase = ''
    make -C 'src'
  '';

  checkPhase = ''
    make -C 'src' check
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(cat package/commands); do
      mv src/$f $out/bin/
    done
  '';

  meta = with stdenv.lib; {
    description = "UNIX init scheme with service supervision";
    license = licenses.bsd3;
    homepage = "http://smarden.org/runit";
    maintainers = with maintainers; [ rickynils ];
    platforms = platforms.linux;
  };
}
