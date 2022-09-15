{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "jdupes";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "jbruchon";
    repo  = "jdupes";
    rev   = "v${version}";
    sha256 = "sha256-nDyRaV49bLVHlyqKJ7hf6OBWOLCfmHrTeHryK091c3w=";
    # Unicode file names lead to different checksums on HFS+ vs. other
    # filesystems because of unicode normalisation. The testdir
    # directories have such files and will be removed.
    postFetch = "rm -r $out/testdir";
  };

  patches = [
    (fetchpatch {
      name = "darwin-stack-size.patch";
      url = "https://github.com/jbruchon/jdupes/commit/8f5b06109b44a9e4316f9445da3044590a6c63e2.patch";
      sha256 = "0saq92v0mm5g979chr062psvwp3i3z23mgqrcliq4m07lvwc7i3s";
    })
  ];

  dontConfigure = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ] ++ lib.optionals stdenv.isLinux [
    "ENABLE_DEDUPE=1"
    "STATIC_DEDUPE_H=1"
  ] ++ lib.optionals stdenv.cc.isGNU [
    "HARDEN=1"
  ];

  enableParallelBuilding = true;

  doCheck = false; # broken Makefile, the above also removes tests

  postInstall = ''
    install -Dm444 -t $out/share/doc/jdupes CHANGES LICENSE README.md
  '';

  meta = with lib; {
    description = "A powerful duplicate file finder and an enhanced fork of 'fdupes'";
    longDescription = ''
      jdupes is a program for identifying and taking actions upon
      duplicate files. This fork known as 'jdupes' is heavily modified
      from and improved over the original.
    '';
    homepage = "https://github.com/jbruchon/jdupes";
    license = licenses.mit;
    maintainers = with maintainers; [ romildo ];
  };
}
