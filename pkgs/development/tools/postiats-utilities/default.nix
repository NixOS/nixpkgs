{ lib, stdenv, fetchFromGitHub, python3, python3Packages }:

stdenv.mkDerivation rec {
  pname = "postiats-utilities";
  version = "2.1.1";
  src = fetchFromGitHub {
    owner = "Hibou57";
    repo = "PostiATS-Utilities";
    rev = "v${version}";
    sha256 = "sha256-QeBbv5lwqL2ARjB+RGyBHeuibaxugffBLhC9lYs+5tE=";
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
    libdir="$out/${python3.sitePackages}"
    mkdir -p "$libdir"
    cp -r postiats "$libdir"

    mkdir -p "$out/bin"
    install pats-* "$out/bin"

    wrapPythonPrograms
  '';
}
