{ stdenv, fetchgit, curl, fuse, libxml2, pkgconfig }:

let
  version = "2-20150109";
  srcs = {
    boxfs2 = fetchgit {
      url = git://github.com/drotiro/boxfs2.git;
      rev = "d7018b0546d2dae956ae3da3fb95d2f63fa6d3ff";
      sha256 = "c22402373589221371f32ec9c86813d5d41aeb1f3a8e2004019019af2f1d8785";
    };
    libapp = fetchgit {
      url = git://github.com/drotiro/libapp.git;
      rev = "febebe2bc0fb88d57bdf4eb4a2a54c9eeda3f3d8";
      sha256 = "dbae0e80cd926a45dcf267d33ed03434b377c758a4d1d556f39f7f17255a650e";
    };
    libjson = fetchgit {
      url = git://github.com/vincenthz/libjson.git;
      rev = "75a7f50fca2c667bc5f32cdd6dd98f2b673f6657";
      sha256 = "7c1c71b2cc61dce06870d33f07f91bc2fccd3f1e3440bb5c30d41282dfd01aee";
    };
  };
in stdenv.mkDerivation {
  name = "boxfs-${version}";

  src = srcs.boxfs2;
  prePatch = with srcs; ''
    substituteInPlace Makefile --replace "git pull" "true"
    cp -a --no-preserve=mode ${libapp} libapp
    cp -a --no-preserve=mode ${libjson} libjson
  '';

  buildInputs = [ curl fuse libxml2 pkgconfig ];

  buildFlags = "static";

  installPhase = ''
    mkdir -p $out/bin
    install boxfs boxfs-init $out/bin
  '';

  meta = with stdenv.lib; {
    description = "FUSE file system for box.com accounts";
    longDescription = ''
      Store files on box.com (an account is required). The first time you run
      boxfs, you will need to complete the authentication (oauth2) process and
      grant access to your box.com account. Just follow the instructions on
      the terminal and in your browser. When you've done using your files,
      unmount the file system with `fusermount -u mountpoint`.
    '';
    homepage = https://github.com/drotiro/boxfs2;
    license = with licenses; gpl3;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
