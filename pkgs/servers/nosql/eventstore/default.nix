{ stdenv, fetchFromGitHub, git, mono, v8, runtimeShell }:

# There are some similarities with the pinta derivation. We should
# have a helper to make it easy to package these Mono apps.

stdenv.mkDerivation rec {
  name = "EventStore-${version}";
  version = "4.1.1";
  src = fetchFromGitHub {
    owner  = "EventStore";
    repo   = "EventStore";
    rev    = "oss-v${version}";
    sha256 = "1069ncb9ps1wi71yw1fzkfd9rfsavccw8xj3a3miwd9x72w8636f";
  };

  buildPhase = ''
    mkdir -p src/libs/x64/nixos
    pushd src/EventStore.Projections.v8Integration
    cc -o ../libs/x64/nixos/libjs1.so -fPIC -lv8 -shared -std=c++0x *.cpp
    popd

    patchShebangs build.sh
    ./build.sh ${version} release nixos
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib/eventstore/clusternode}
    cp -r bin/clusternode/* $out/lib/eventstore/clusternode/
    cat > $out/bin/clusternode << EOF
    #!${runtimeShell}
    exec ${mono}/bin/mono $out/lib/eventstore/clusternode/EventStore.ClusterNode.exe "\$@"
    EOF
    chmod +x $out/bin/clusternode
  '';

  nativeBuildInputs = [ git ];
  buildInputs = [ v8 mono ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];
  dontStrip = true;

  meta = {
    homepage = https://geteventstore.com/;
    description = "Event sourcing database with processing logic in JavaScript";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = [ "x86_64-linux" ];
  };
}
