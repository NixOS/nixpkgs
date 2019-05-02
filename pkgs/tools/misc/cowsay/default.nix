{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec{
  version = "3.03+dfsg2";
  name = "cowsay-${version}";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/c/cowsay/cowsay_${version}.orig.tar.gz";
    sha256 = "0ghqnkp8njc3wyqx4mlg0qv0v0pc996x2nbyhqhz66bbgmf9d29v";
  };

  buildInputs = [ perl ];

  postBuild = ''
    substituteInPlace cowsay --replace "%BANGPERL%" "!${perl}/bin/perl" \
      --replace "%PREFIX%" "$out"
  '';

  installPhase = ''
    mkdir -p $out/{bin,man/man1,share/cows}
    install -m755 cowsay $out/bin/cowsay
    ln -s cowsay $out/bin/cowthink
    install -m644 cowsay.1 $out/man/man1/cowsay.1
    ln -s cowsay.1 $out/man/man1/cowthink.1
    install -m644 cows/* -t $out/share/cows/
  '';

  meta = with stdenv.lib; {
    description = "A program which generates ASCII pictures of a cow with a message";
    homepage = https://en.wikipedia.org/wiki/Cowsay;
    license = licenses.gpl1;
    platforms = platforms.all;
    maintainers = [ maintainers.rob ];
  };
}
