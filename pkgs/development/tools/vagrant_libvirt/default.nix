{ stdenv, fetchurl, fetchpatch, git, dpkg, curl, libarchive, openssl, ruby, buildRubyGem, libiconv
, libxml2, libxslt, pkgconfig, makeWrapper, p7zip, xar, gzip, cpio, bundix, bundler, bundlerEnv, libvirt }:

stdenv.mkDerivation rec {
  name = "vagrant-${version}";
  version = "1.9.5";
  src = fetchurl {
    url = "https://github.com/mitchellh/vagrant/archive/v${version}.tar.gz";
    sha256 = "0ancxh93ziyjak1wvjnbg2x7jv1brgbd4pxyi51zkdj867g8xsv9";
  };

  buildInputs = [ makeWrapper bundler libvirt pkgconfig bundix git ]
    ++ stdenv.lib.optional stdenv.isDarwin [ p7zip xar gzip cpio ];

  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  #env = "test";
  env = bundlerEnv {
    inherit name;
    inherit ruby;
    inherit gemfile;
    inherit lockfile;
    inherit gemset;
    #gemfile = ./Gemfile;
    #lockfile = ./Gemfile.lock;
    #gemset = ./gemset.nix;
  };

  #phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin;
    #cp ${gemfile} $out/Gemfile
    #cp ${lockfile} $out/Gemfile.lock
    cp -r * "$out"

    wrapProgram "$out/bin/vagrant" --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libxml2 libxslt ]}" \
                                   --prefix LD_LIBRARY_PATH : "$out/lib"
  '';

  meta = with stdenv.lib; {
    description = "A tool for building complete development environments";
    homepage    = http://vagrantup.com;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 globin jgeerds kamilchm eleanor ];
    platforms   = with platforms; linux ++ darwin;
  };

}
