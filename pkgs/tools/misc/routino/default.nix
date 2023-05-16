{ lib, stdenv, fetchurl, fetchpatch, perl, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "routino";
<<<<<<< HEAD
  version = "3.4.1";

  src = fetchurl {
    url = "https://routino.org/download/${pname}-${version}.tgz";
    hash = "sha256-C6qNKljRdV0ProbgSxfrZLgZH+Pl8kcpKmTb83GLhSs=";
=======
  version = "3.3.3";

  src = fetchurl {
    url = "https://routino.org/download/${pname}-${version}.tgz";
    sha256 = "1xa7l2bjn832nk6bc7b481nv8hd2gj41jwhg0d2qy10lqdvjpn5b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patchFlags = [ "-p0" ];
  patches = lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/18fd229516a46e7272003acbe555735b2a902db7/gis/routino/files/patch-Makefile_conf.diff";
      sha256 = "1b7hpa4sizansnwwxq1c031nxwdwh71pg08jl9z9apiab8pjsn53";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/18fd229516a46e7272003acbe555735b2a902db7/gis/routino/files/patch-src_Makefile_dylib_extension.diff";
      sha256 = "1kigxcfr7977baxdsfvrw6q453cpqlzqakhj7av2agxkcvwyilpv";
    })
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.conf \
      --subst-var-by PREFIX $out
  '';

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib bzip2 ];

  outputs = [ "out" "doc" ];

  CLANG = lib.optionalString stdenv.cc.isClang "1";

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "http://www.routino.org/";
<<<<<<< HEAD
    changelog = "http://routino.org/software/NEWS.txt";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "OpenStreetMap Routing Software";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux ++ darwin;
  };
}
