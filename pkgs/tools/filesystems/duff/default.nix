{ stdenv, fetchFromGitHub, autoreconfHook, gettext }:

let version = "0.5.2"; in
stdenv.mkDerivation rec {
  name = "duff-${version}";

  src = fetchFromGitHub {
    sha256 = "0yfm910wjj6z0f0cg68x59ykf4ql5m49apzy8sra00f8kv4lpn53";
    rev = version;
    repo = "duff";
    owner = "elmindreda";
  };

  nativeBuildInputs = [ autoreconfHook gettext ];

  preAutoreconf = ''
    # duff is currently badly packaged, requiring us to do extra work here that
    # should be done upstream. If that is ever fixed, this entire phase can be
    # removed along with all buildInputs.

    # gettexttize rightly refuses to run non-interactively:
    cp ${gettext}/bin/gettextize .
    substituteInPlace gettextize \
      --replace "read dummy" "echo '(Automatically acknowledged)' #"
    ./gettextize
    sed 's@po/Makefile.in\( .*\)po/Makefile.in@po/Makefile.in \1@' \
      -i configure.ac
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Quickly find duplicate files";
    homepage = http://duff.dreda.org/;
    license = licenses.zlib;
    longDescription = ''
      Duff is a Unix command-line utility for quickly finding duplicates in
      a given set of files.
    '';
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; all;
  };
}
