{ stdenv, fetchurl, makeWrapper, ruby, bundler, bundlerEnv, git, postgresql, libpcap, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "metasploit-framework-${version}";
  version = "4.12.5";


  src = fetchurl {
    url = "https://github.com/rapid7/metasploit-framework/archive/4.12.5.tar.gz";
    sha256 = "0xwkshxprpjssda6lwys0f12dp0q3sgxvdzwciyhsgxkcf672cwv";
  };


  buildInputs = [makeWrapper bundler git postgresql libpcap sqlite zlib ruby];

  installPhase = ''
    mkdir -p $out/share/msf
    mkdir -p $out/bin

    cp -r * $out/share/msf

    bundle install --path=$out/.gem

    for i in $out/share/msf/msf*; do
        makeWrapper $i $out/bin/$(basename $i) \
	  --prefix RUBYLIB : "$out/share/msf/lib" \
          --prefix GEM_PATH : "$out/.gem/ruby/2.3.0" \
          --prefix GEM_PATH : "~/.gem/ruby/2.3.0/cache"
    done
  '';

  postInstall = ''
    patchShebangs $out/share/msf
  '';

  meta = {
    description = "Metasploit Framework - a collection of exploits";
    homepage = https://github.com/rapid7/metasploit-framework/wiki;
  };
}
