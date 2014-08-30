{ stdenv, fetchurl, scons, boost, gperftools, pcre, snappy }:

let version = "2.6.4";
    system-libraries = [
      "tcmalloc"
      "pcre"
      "boost"
      "snappy"
      # "v8"      -- mongo still bundles 3.12 and does not work with 3.15+
      # "stemmer" -- not nice to package yet (no versioning, no makefile, no shared libs)
      # "yaml"    -- it seems nixpkgs' yamlcpp (0.5.1) is problematic for mongo
    ];
    system-lib-args = stdenv.lib.concatStringsSep " "
                          (map (lib: "--use-system-${lib}") system-libraries);

in stdenv.mkDerivation rec {
  name = "mongodb-${version}";

  src = fetchurl {
    url = "http://downloads.mongodb.org/src/mongodb-src-r${version}.tar.gz";
    sha256 = "1h4rrgcb95234ryjma3fjg50qsm1bnxjx5ib0c3p9nzmc2ji2m07";
  };

  nativeBuildInputs = [ scons boost gperftools pcre snappy ];

  postPatch = ''
    substituteInPlace SConstruct \
        --replace "Environment( BUILD_DIR" "Environment( ENV = os.environ, BUILD_DIR"
  '';

  buildPhase = ''
    scons all --release ${system-lib-args}
  '';

  installPhase = ''
    mkdir -p $out/lib
    scons install --release --prefix=$out ${system-lib-args}
  '';

  meta = {
    description = "a scalable, high-performance, open source NoSQL database";
    homepage = http://www.mongodb.org;
    license = stdenv.lib.licenses.agpl3;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
