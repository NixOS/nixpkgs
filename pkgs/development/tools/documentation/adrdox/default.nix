{ stdenv, fetchFromGitHub, dmd }:

stdenv.mkDerivation rec {
  pname = "adrdox";
  version = "v1.0.0";

  src = fetchFromGitHub {
    owner = "adamdruppe";
    repo = "adrdox";
    rev = version;
    sha256 = "1w0y158ab36385jhg6q9xjlb8cilfwimlh43q86n40l10vhn4bk9";
  };

  buildInputs = [ dmd ];

  patches = [
    # Allow building on non-64-bit systems. adrdox works fine on those
    # platforms.
    ./cross-platform.patch
  ];

  # We need a custom install phase because the makefile lacks an install
  # target. If a future version of adrdox gets an install target, the custom
  # install phase may be removed.
  installPhase = ''
    runHook preInstall

    install -d $out/bin
    install doc2 $out/bin
    # doc2 expects the asset files to be in the same directory as the binary.
    install skeleton-default.html script.js search-docs.js style.css $out/bin

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Documentation generator for D";
    homepage = "https://github.com/adamdruppe/adrdox";
    license = licenses.boost;
    maintainers = [ maintainers.chloekek ];
    platforms = dmd.meta.platforms;
  };
}
