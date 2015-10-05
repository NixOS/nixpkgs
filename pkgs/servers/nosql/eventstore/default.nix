{ stdenv, fetchgit, fetchpatch, git, mono, v8, icu }:

# There are some similarities with the pinta derivation. We should
# have a helper to make it easy to package these Mono apps.

stdenv.mkDerivation rec {
  name = "EventStore-${version}";
  version = "3.0.3";
  src = fetchgit {
    url = "https://github.com/EventStore/EventStore.git";
    rev = "a1382252dd1ed0554ddb04015cdb2cbc1b0a65c1";
    sha256 = "07ir6jlli2q1yvsnyw8r8dfril6h1wmfj98yf7a6k81585v2mc6g";
    leaveDotGit = true;
  };

  patches = [
    # see: https://github.com/EventStore/EventStore/issues/461
    (fetchpatch {
      url = https://github.com/EventStore/EventStore/commit/9a0987f19935178df143a3cf876becaa1b11ffae.patch;
      sha256 = "04qw0rb1pypa8dqvj94j2mwkc1y6b40zrpkn1d3zfci3k8cam79y";
    })
  ];

  buildPhase = ''
    ln -s ${v8}/lib/libv8.so src/libs/libv8.so
    ln -s ${icu.out}/lib/libicui18n.so src/libs/libicui18n.so
    ln -s ${icu.out}/lib/libicuuc.so src/libs/libicuuc.so

    patchShebangs build.sh
    ./build.sh js1
    ./build.sh quick ${version}
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib/eventstore/clusternode}
    cp -r bin/clusternode/* $out/lib/eventstore/clusternode/
    cat > $out/bin/clusternode << EOF
    #!/bin/sh
    exec ${mono}/bin/mono $out/lib/eventstore/clusternode/EventStore.ClusterNode.exe "\$@"
    EOF
    chmod +x $out/bin/clusternode
  '';

  buildInputs = [ git v8 mono ];

  dontStrip = true;

  meta = {
    homepage = https://geteventstore.com/;
    description = "Event sourcing database with processing logic in JavaScript";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
