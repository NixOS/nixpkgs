{ stdenv, fetchurl, scons, boost, gperftools, pcre, snappy
, zlib, libyamlcpp, sasl, openssl, libpcap, wiredtiger
}:

with stdenv.lib;

let version = "3.0.5";
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
      zlib libyamlcpp sasl openssl libpcap
    ] ++ optional stdenv.is64bit wiredtiger;

    other-args = concatStringsSep " " ([
      # these are opt-in, lol
      "--cc-use-shell-environment"
      "--cxx-use-shell-environment"

      "--c++11=on"
      "--ssl"
      #"--rocksdb" # Don't have this packaged yet
      "--wiredtiger=${if stdenv.is64bit then "on" else "off"}"
      "--js-engine=v8-3.25"
      "--use-sasl-client"
      "--disable-warnings-as-errors"
      "--variant-dir=nixos" # Needed so we don't produce argument lists that are too long for gcc / ld
      "--extrapath=${concatStringsSep "," buildInputs}"
    ] ++ map (lib: "--use-system-${lib}") system-libraries);

in stdenv.mkDerivation rec {
  name = "mongodb-${version}";

  src = fetchurl {
    url = "http://downloads.mongodb.org/src/mongodb-src-r${version}.tar.gz";
    sha256 = "1nvzbxgyjsp72w4fvfd8zxpj38zv0whn5p53jv9v2rdaj5wnmc85";
  };

  nativeBuildInputs = [ scons ];
  inherit buildInputs;

  postPatch = ''
    # fix environment variable reading
    substituteInPlace SConstruct \
        --replace "env = Environment(" "env = Environment(ENV = os.environ,"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''

    substituteInPlace src/third_party/s2/s1angle.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s1interval.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s2cap.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s2latlng.cc --replace drem remainder
    substituteInPlace src/third_party/s2/s2latlngrect.cc --replace drem remainder
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
