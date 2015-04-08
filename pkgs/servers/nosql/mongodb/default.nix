{ stdenv, fetchurl, scons, boost, gperftools, pcre, snappy
, zlib, libyamlcpp, sasl, openssl, libpcap, wiredtiger
}:

with stdenv.lib;

let version = "3.0.1";
    system-libraries = [
      "pcre"
      "wiredtiger"
      "boost"
      "snappy"
      "zlib"
      # "v8"
      # "stemmer" -- not nice to package yet (no versioning, no makefile, no shared libs)
      "yaml"
    ] ++ optionals stdenv.isLinux [ "tcmalloc" ];
    buildInputs = [
      sasl boost gperftools pcre snappy
      zlib libyamlcpp sasl openssl libpcap wiredtiger
    ];

    other-args = concatStringsSep " " ([
      "--c++11=on"
      "--ssl"
      #"--rocksdb" # Don't have this packaged yet
      "--wiredtiger=on"
      "--js-engine=v8-3.25"
      "--use-sasl-client"
      "--variant-dir=nixos" # Needed so we don't produce argument lists that are too long for gcc / ld
      "--extrapath=${concatStringsSep "," buildInputs}"
    ] ++ map (lib: "--use-system-${lib}") system-libraries);

in stdenv.mkDerivation rec {
  name = "mongodb-${version}";

  src = fetchurl {
    url = "http://downloads.mongodb.org/src/mongodb-src-r${version}.tar.gz";
    sha256 = "04qjw7b98h37g8rcih7va3rvg2z95ly38bg181a4nfkak50hd638";
  };

  nativeBuildInputs = [ scons ];
  inherit buildInputs;

  postPatch = ''
    # fix environment variable reading
    substituteInPlace SConstruct \
        --replace "env = Environment(" "env = Environment(ENV = os.environ,"
  '';

  buildPhase = ''
    scons -j $NIX_BUILD_CORES core --release ${other-args}
  '';

  installPhase = ''
    mkdir -p $out/lib
    scons -j $NIX_BUILD_CORES install --release --prefix=$out ${other-args}
  '';

  enableParallelBuilding = true;

  meta = {
    description = "a scalable, high-performance, open source NoSQL database";
    homepage = http://www.mongodb.org;
    license = licenses.agpl3;

    maintainers = with maintainers; [ bluescreen303 offline wkennington ];
    platforms = platforms.unix;
  };
}
