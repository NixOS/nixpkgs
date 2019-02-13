{ stdenv, lib, fetchFromGitHub, fetchgit, git, cmake, pkgconfig
, openssl, protobuf, boost, zlib }:

with lib;

let
  repos = [
    {
      url = "https://github.com/mellery451/libarchive.git";
      tag = "e78e48ea4e102fef7f379bc8f10afbfbf25633a6";
      sha256 = "13gaxhjf4hs2smpwz5q1wwz7pphyd5n8b9000dglfvjwf4h6y7jf";
    }
  ];
in stdenv.mkDerivation rec {
  name = "rippled-${version}";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "ripple";
    repo = "rippled";
    rev = version;
    sha256 = "1vg679vcymrwxxabd32m9r6bv7djgxl7j3qw82rz0zackd51wcii";
  };

  hardeningDisable = ["format"];
  cmakeFlags = ["-Dstatic=OFF"];

  nativeBuildInputs = [ pkgconfig cmake git ];
  buildInputs = [ openssl openssl.dev protobuf boost zlib ];

  postPatch = ''
    ${concatMapStrings (repo: let
      src = fetchgit {
        inherit (repo) url sha256;
        rev = repo.tag;
        leaveDotGit = true;
        fetchSubmodules = true;
      };
      replaceUrl = repo.replaceUrl or "GIT_REPOSITORY ${repo.url}";
      replaceTag = repo.replaceTag or "GIT_TAG ${repo.tag}";
    in ''
      substituteInPlace CMakeLists.txt --replace "${replaceUrl}" "GIT_REPOSITORY file://${src}"
      substituteInPlace CMakeLists.txt --replace "${replaceTag}" "GIT_TAG ${repo.tag}"
    '') repos}
  '';

  doCheck = true;
  checkPhase = ''
    ./rippled --unittest
  '';

  meta = with stdenv.lib; {
    description = "Ripple P2P payment network reference server";
    homepage = https://ripple.com;
    maintainers = with maintainers; [ ehmry offline ];
    license = licenses.isc;
    platforms = [ "x86_64-linux" ];
  };
}
