{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "influxdb-${version}";
  version = "0.7.0";
  arch = if stdenv.system == "x86_64-linux" then "amd64" else "386";

  src = fetchurl {
    url = "http://s3.amazonaws.com/influxdb/${name}.${arch}.tar.gz";
    sha256 = if arch == "amd64" then
        "1mvi21z83abnprzj0n8r64ly9s48i5l7ndcrci7nk96z8xab7w3q" else
        "1zgxbfnam4r31g9yfwznhb7l4hf7s5sylhll92zr8q0qjhr4cj2b";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    install -D influxdb $out/bin/influxdb
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $out/bin/influxdb
    wrapProgram "$out/bin/influxdb" \
        --prefix LD_LIBRARY_PATH : "${stdenv.gcc.gcc}/lib:${stdenv.gcc.gcc}/lib64"

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
