{ lib, stdenv, fetchFromSourcehut, buildPackages }:

stdenv.mkDerivation rec {
  pname = "scdoc";
  version = "1.11.2";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = pname;
    rev = version;
    sha256 = "07c2vmdgqifbynm19zjnrk7h102pzrriv73izmx8pmd7b3xl5mfq";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-static" "" \
      --replace "/usr/local" "$out"
  '';

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "HOST_SCDOC=${buildPackages.scdoc}/bin/scdoc"
  ];

  doCheck = true;

  meta = with lib; {
    description = "A simple man page generator";
    longDescription = ''
      scdoc is a simple man page generator written for POSIX systems written in
      C99.
    '';
    homepage = "https://git.sr.ht/~sircmpwn/scdoc";
    changelog = "https://git.sr.ht/~sircmpwn/scdoc/refs/${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
