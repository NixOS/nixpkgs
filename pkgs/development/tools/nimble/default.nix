{ stdenv, fetchFromGitHub, nim }:

let
  srcs = {
    nimble = fetchFromGitHub {
      owner = "nim-lang";
      repo = "nimble";
      rev = "v0.7.2";
      sha256 = "0j9b519cv91xwn6k0alynakh7grbq4m6yy5bdwdrqmc7lag35r0i";
    };
    nim = fetchFromGitHub {
      owner = "nim-lang";
      repo = "nim";
      rev = "v0.13.0";
      sha256 = "14grhkwdva4wmvihm1413ly86sf0qk96bd473pvsbgkp46cg8rii";
    };
  };
in
stdenv.mkDerivation rec {
  name = "nimble-${version}";
  version = "0.7.2";

  src = srcs.nimble;

  buildInputs = [ nim ];

  postUnpack = ''
    mkdir -p $sourceRoot/vendor
    ln -s ${srcs.nim} $sourceRoot/vendor/nim
  '';
  buildPhase   = ''
    nim c src/nimble
  '';
  installPhase = "installBin src/nimble";

  meta = with stdenv.lib; {
    description = "Package manager for the Nim programming language";
    homepage = https://github.com/nim-lang/nimble;
    license = licenses.bsd2;
    maintainers = with maintainers; [ kamilchm ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
