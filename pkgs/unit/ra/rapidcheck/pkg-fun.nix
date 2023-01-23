{ lib, stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "rapidcheck";
  version = "unstable-2020-12-19";

  src = fetchFromGitHub {
    owner = "emil-e";
    repo  = "rapidcheck";
    rev   = "b78f89288c7e086d06e2a1e10b605d8375517a8a";
    sha256 = "0fj11gbhkaxbsgix2im7vdfvr26l75b8djk462sfw8xrwrfkjbdz";
  };

  nativeBuildInputs = [ cmake ];

  # Install the extras headers
  postInstall = ''
    cp -r $src/extras $out
    chmod -R +w $out/extras
    rm $out/extras/CMakeLists.txt
    rm $out/extras/**/CMakeLists.txt
  '';

  meta = with lib; {
    description = "A C++ framework for property based testing inspired by QuickCheck";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
