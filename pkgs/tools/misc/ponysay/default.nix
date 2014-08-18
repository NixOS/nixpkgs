{ stdenv, fetchurl, python3, texinfo, makeWrapper }:

stdenv.mkDerivation rec {
  name = "ponysay-3.0.1";

  src = fetchurl {
    url = "https://github.com/erkin/ponysay/archive/3.0.1.tar.gz";
    sha256 = "ab281f43510263b2f42a1b0a9097ee7831b3e33a9034778ecb12ccb51f6915ee";
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
    homepage = http://terse.tk/ponysay/;
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [ bodil ];
  };
}
