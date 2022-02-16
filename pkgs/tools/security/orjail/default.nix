{ lib
, stdenv
, fetchFromGitHub
, tor
, iptables
, makeWrapper
, ncurses
, coreutils-full
, iproute2
, bc
, gnugrep
, sudo
, procps
, findutils
}:

stdenv.mkDerivation rec {
  pname = "orjail";
  version = "1.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "06bwqb3l7syy4c1d8xynxwakmdxvm3qfm8r834nidsknvpdckd9z";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    patchShebangs make-helper.bsh
    mkdir bin
    mv usr/sbin/orjail bin/orjail
    rm -r usr
  '';

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  postInstall = ''
    # mktemp fails with /tmp path prefix, will work without it anyway
    # This issue is already fixed upstream and will be solved in versions
    # later than 1.1.
    # https://github.com/orjail/orjail/issues/78
    substituteInPlace $out/bin/orjail \
      --replace 'mktemp /tmp/' 'mktemp ' \

    wrapProgram $out/bin/orjail \
      --prefix PATH : ${lib.makeBinPath [
        ncurses coreutils-full tor iptables iproute2 gnugrep bc
        sudo procps findutils
      ]}
  '';

  meta = with lib; {
    description = "Force programs to exclusively use tor network";
    homepage = "https://github.com/orjail/orjail";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
