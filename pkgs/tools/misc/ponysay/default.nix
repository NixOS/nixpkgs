{ lib, stdenv, fetchFromGitHub, python3, texinfo, makeWrapper }:

stdenv.mkDerivation rec {
  name = "ponysay";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "erkin";
    repo = "ponysay";
    rev = version;
    sha256 = "sha256-R2B0TU3ZSEncGsijKgvhaHIbcZa5Dx/jVPxrILBaoVw=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 texinfo ];

  inherit python3;

  installPhase = ''
    find -type f -name "*.py" | xargs sed -i "s@/usr/bin/env python3@$python3/bin/python3@g"
    substituteInPlace setup.py --replace \
        "fileout.write(('#!/usr/bin/env %s\n' % env).encode('utf-8'))" \
        "fileout.write(('#!%s/bin/%s\n' % (os.environ['python3'], env)).encode('utf-8'))"
    python3 setup.py --prefix=$out --freedom=partial install \
        --with-shared-cache=$out/share/ponysay \
        --with-bash
  '';

  meta = with lib; {
    description = "Cowsay reimplemention for ponies";
    homepage = "https://github.com/erkin/ponysay";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bodil ];
    platforms = platforms.unix;
  };
}
