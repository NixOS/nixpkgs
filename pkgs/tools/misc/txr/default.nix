{ lib, stdenv, fetchurl, libffi, coreutils }:

stdenv.mkDerivation rec {
  pname = "txr";
  version = "280";

  src = fetchurl {
    url = "http://www.kylheku.com/cgit/txr/snapshot/${pname}-${version}.tar.bz2";
    sha256 = "sha256-1iqWerUehLFPM63ZjJYY6xo9oHoNK7ne/a6M3+4L4so=";
  };

  buildInputs = [ libffi ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "tests";

  postPatch = ''
    # Fixup references to /usr/bin in tests
    substituteInPlace tests/017/realpath.tl --replace /usr/bin /bin
    substituteInPlace tests/017/realpath.expected --replace /usr/bin /bin

    substituteInPlace tests/018/process.tl --replace /usr/bin/env ${lib.getBin coreutils}/bin/env
  '';

  # Remove failing tests -- 018/chmod tries setting sticky bit
  preCheck = "rm -rf tests/018/chmod*";

  postInstall = ''
    d=$out/share/vim-plugins/txr
    mkdir -p $d/{syntax,ftdetect}

    cp {tl,txr}.vim $d/syntax/

    cat > $d/ftdetect/txr.vim <<EOF
      au BufRead,BufNewFile *.txr set filetype=txr | set lisp
      au BufRead,BufNewFile *.tl,*.tlo set filetype=tl | set lisp
    EOF
  '';

  meta = with lib; {
    description = "Programming language for convenient data munging";
    license = licenses.bsd2;
    homepage = "http://nongnu.org/txr";
    maintainers = with lib.maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
