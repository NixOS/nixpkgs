{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "runit-${version}";
  version = "2.1.2";

  src = fetchurl {
    url = "http://smarden.org/runit/${name}.tar.gz";
    sha256 = "065s8w62r6chjjs6m9hapcagy33m75nlnxb69vg0f4ngn061dl3g";
  };

  outputs = [ "out" "man" ];

  sourceRoot = "admin/${name}";

  doCheck = true;

  postPatch = ''
    sed -i 's,-static,,g' src/Makefile
  '';

  preBuild = ''
    cd src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -t $out/bin $(< ../package/commands)

    mkdir -p $man/share/man
    cp -r ../man $man/share/man/man8
  '';

  meta = with stdenv.lib; {
    description = "UNIX init scheme with service supervision";
    license = licenses.bsd3;
    homepage = "http://smarden.org/runit";
    maintainers = with maintainers; [ rickynils joachifm ];
    platforms = platforms.linux;
  };
}
