{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.5.3";
  name = "logstash-${version}";

  src = fetchurl {
    url = "https://download.elasticsearch.org/logstash/logstash/logstash-${version}.tar.gz";
    sha256 = "1an476k4q2shdxvhcx4fzbrcpk6isjrrvzlb6ivxfqg5fih3cg7b";
  };

  dontBuild    = true;
  dontPatchELF = true;
  dontStrip    = true;
  dontPatchShebangs = true;

      #sed -i $f '1 s@^.*$@#!'$out'/vendor/jruby/bin/jruby@g'
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/vendor
    mkdir -p $out/lib
    cp -a bin $out
    cp -a vendor $out
    cp -a lib $out
    cp -a Gemfile* $out

    for f in $out/vendor/bundle/jruby/*/gems/bundler-*/lib/bundler/templates/Executable{,.standalone}; do
      chmod -x $f
    done

    patchShebangs $out/bin
    patchShebangs $out/vendor

    for f in $out/vendor/bundle/jruby/*/gems/bundler-*/lib/bundler/templates/Executable{,.standalone}; do
      chmod +x $f
    done
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    homepage    = http://www.elasticsearch.org;
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ wjlroe cstrahan ];
  };
}
