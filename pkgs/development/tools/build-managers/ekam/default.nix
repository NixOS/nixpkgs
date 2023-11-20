{ lib, stdenv, fetchFromGitHub, capnproto }:

stdenv.mkDerivation {
  pname = "ekam";
  version = "unstable-2021-09-18";

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "ekam";
    rev = "77c338f8bd8f4a2ce1e6199b2a52363f1fccf388";
    sha256 = "0q4bizlb1ykzdp4ca0kld6xm5ml9q866xrj3ijffcnyiyqr51qr8";
  };

  # The capnproto *source* is required to build ekam.
  # https://github.com/capnproto/ekam/issues/5
  #
  # Specifically, the git version of the source is required, as
  # capnproto release tarballs do not include ekam rule files.
  postUnpack = ''
    mkdir -p $sourceRoot/deps
    cp -r ${capnproto.src} $sourceRoot/deps/capnproto
  '';

  postPatch = ''
    # A single capnproto test file expects to be able to write to
    # /var/tmp.  We change it to use /tmp because /var is not available
    # under nix-build.
    substituteInPlace deps/capnproto/c++/src/kj/filesystem-disk-test.c++ \
      --replace "/var/tmp" "/tmp"
  '';

  # NIX_ENFORCE_PURITY prevents ld from linking against anything outside
  # of the nix store -- but ekam builds capnp locally and links against it,
  # so that causes the build to fail. So, we turn this off.
  #
  # See: https://nixos.wiki/wiki/Development_environment_with_nix-shell#Troubleshooting
  preBuild = ''
    unset NIX_ENFORCE_PURITY
  '';

  makeFlags = [
    "PARALLEL=$(NIX_BUILD_CORES)"
  ];

  installPhase = ''
    mkdir $out
    cp -r bin $out

    # Remove capnproto tools; there's a separate nix package for that.
    rm $out/bin/capnp*
    # Don't distribute ekam-bootstrap, which is not needed outside this build.
    rm $out/bin/ekam-bootstrap
  '';

  meta = with lib; {
    description = ''Build system ("make" in reverse)'';
    longDescription = ''
      Ekam ("make" spelled backwards) is a build system which automatically
      figures out what to build and how to build it purely based on the
      source code. No separate "makefile" is needed.
    '';
    homepage = "https://github.com/capnproto/ekam";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.garrison ];
  };
}
