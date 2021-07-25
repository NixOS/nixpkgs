{ lib, stdenv, fetchFromGitHub, python3, python3Packages }:

stdenv.mkDerivation rec {
  pname = "postiats-utilities";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "Hibou57";
    repo = "PostiATS-Utilities";
    rev = "v${version}";
    sha256 = "1238zp6sh60rdqbzff0w5c36w2z1jr44qnv43qidmcp19zvr7jd5";
  };

  meta = with lib; {
    homepage = "https://github.com/Hibou57/PostiATS-Utilities";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.ttuegel ];
  };

  buildInputs = [ python3 python3Packages.wrapPython ];

  postPatch = ''
    for f in pats-* postiats/*.py; do
      sed -i "$f" -e "1 s,python3,python,"
    done
  '';

  installPhase = ''
    libdir="$out/lib/${python3.libPrefix}/site-packages"
    mkdir -p "$libdir"
    cp -r postiats "$libdir"

    mkdir -p "$out/bin"
    install pats-* "$out/bin"

    wrapPythonPrograms
  '';
}
