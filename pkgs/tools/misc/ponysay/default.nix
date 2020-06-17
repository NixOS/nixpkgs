{ stdenv, fetchurl, python3, texinfo, makeWrapper }:

stdenv.mkDerivation {
  name = "ponysay-3.0.3";

  src = fetchurl {
    url = "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz";
    sha256 = "12mjabf5cpp5dgg63s19rlyq3dhhpzzy2sa439yncqzsk7rdg0n3";
  };

  buildInputs = [ python3 texinfo makeWrapper ];

  inherit python3;

  phases = "unpackPhase installPhase fixupPhase";

  installPhase = ''
    find -type f -name "*.py" | xargs sed -i "s@/usr/bin/env python3@$python3/bin/python3@g"
    substituteInPlace setup.py --replace \
        "fileout.write(('#!/usr/bin/env %s\n' % env).encode('utf-8'))" \
        "fileout.write(('#!%s/bin/%s\n' % (os.environ['python3'], env)).encode('utf-8'))"
    python3 setup.py --prefix=$out --freedom=partial install \
        --with-shared-cache=$out/share/ponysay \
        --with-bash
  '';

  meta = {
    description = "Cowsay reimplemention for ponies";
    homepage = "https://github.com/erkin/ponysay";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ bodil ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
