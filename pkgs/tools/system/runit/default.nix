{ stdenv, fetchurl

# Build runit-init as a static binary
, static ? false
}:

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

  buildInputs = stdenv.lib.optionals static [ stdenv.cc.libc stdenv.cc.libc.static ];

  postPatch = ''
    sed -i "s,\(#define RUNIT\) .*,\1 \"$out/bin/runit\"," src/runit.h
    # usernamespace sandbox of nix seems to conflict with runit's assumptions
    # about unix users. Therefor skip the check
    sed -i '/.\/chkshsgr/d' src/Makefile
  '' + stdenv.lib.optionalString (!static) ''
    sed -i 's,-static,,g' src/Makefile
  '';

  preBuild = ''
    cd src

    # Both of these are originally hard-coded to gcc
    echo cc > conf-cc
    echo cc > conf-ld
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
    platforms = platforms.unix;
  };
}
