{ lib, stdenv, fetchFromGitHub, capnproto }:

stdenv.mkDerivation {
  pname = "ekam";
  version = "2021-09-18";
  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "ekam";
    rev = "77c338f8bd8f4a2ce1e6199b2a52363f1fccf388";
    sha256 = "0q4bizlb1ykzdp4ca0kld6xm5ml9q866xrj3ijffcnyiyqr51qr8";
  };
  builder = ./builder.sh;

  # The capnproto *source* is required to build ekam, so we make it
  # visible as an environment variable in the builder.
  # https://github.com/capnproto/ekam/issues/5
  #
  # Specifically, the git version of the source is required, as
  # capnproto release tarballs do not include ekam rule files.
  capnprotoSrc = capnproto.src;

  meta = with lib; {
    description = ''Build system ("make" in reverse)'';
    longDescription = ''Ekam ("make" spelled backwards) is a build system which automatically figures out what to build and how to build it purely based on the source code. No separate "makefile" is needed.'';
    homepage = "https://github.com/capnproto/ekam";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.garrison ];
  };
}
