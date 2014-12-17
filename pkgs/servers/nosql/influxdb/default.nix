{ stdenv, fetchurl, makeWrapper, zlib, bzip2 }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "influxdb-${version}";
  version = "0.8.2";
  arch = if stdenv.system == "x86_64-linux" then "amd64" else "386";

  src = fetchurl {
    url = "http://s3.amazonaws.com/influxdb/${name}.${arch}.tar.gz";
    sha256 = if arch == "amd64" then
        "0m27agjf9v76w5xms8w3z91k4hxw832nxqr030qzqxynwbxj0vg6" else
        "0bdjpdq4yhfsmvl756xhkd1d8565d19g66l5rlymksc71ps8kbj6";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -D influxdb $out/bin/influxdb
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/influxdb
    wrapProgram "$out/bin/influxdb" \
        --prefix LD_LIBRARY_PATH : "${stdenv.cc.gcc}/lib:${stdenv.cc.gcc}/lib64:${zlib}/lib:${bzip2}/lib"

    mkdir -p $out/share/influxdb
    cp -R admin scripts config.toml $out/share/influxdb
  '';

  meta = with stdenv.lib; {
    description = "Scalable datastore for metrics, events, and real-time analytics";
    homepage = http://influxdb.com/;
    license = licenses.mit;

    maintainers = [ maintainers.offline ];
    platforms = ["i686-linux" "x86_64-linux"];
  };
}
