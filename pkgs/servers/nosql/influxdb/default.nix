{ stdenv, fetchurl, makeWrapper, zlib, bzip2 }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "influxdb-${version}";
  version = "0.8.3";
  arch = if stdenv.system == "x86_64-linux" then "amd64" else "386";

  src = fetchurl {
    url = "http://s3.amazonaws.com/influxdb/${name}.${arch}.tar.gz";
    sha256 = if arch == "amd64" then
        "e625902d403434c799f9d9ffc2592a3880f82d435423fde7174e5e4fe0f41148" else
        "5abe9f432553e66c8aff86c4311eba16b874678d04b52bfe9e2019c01059ec78";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -D influxdb $out/bin/influxdb
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/influxdb
    wrapProgram "$out/bin/influxdb" \
        --prefix LD_LIBRARY_PATH : "${stdenv.cc.cc}/lib:${stdenv.cc.cc}/lib64:${zlib}/lib:${bzip2}/lib"

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
