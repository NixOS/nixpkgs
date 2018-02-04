{ lib, fetchurl, buildRubyGem, bundlerEnv, ruby, libarchive }:

let
  version = "2.0.1";
  url = "https://github.com/hashicorp/vagrant/archive/v${version}.tar.gz";
  sha256 = "1fjfl00n4rsq6khypm56g0vq6l153q128r35zky2ba30bz292ar1";

  deps = bundlerEnv rec {
    name = "${pname}-${version}";
    pname = "vagrant";
    inherit version;

    inherit ruby;
    gemdir = ./.;
    gemset = lib.recursiveUpdate (import ./gemset.nix) {
      vagrant = {
        source = {
          type = "url";
          inherit url sha256;
        };
        inherit version;
      };
    };
  };

in buildRubyGem rec {
  name = "${gemName}-${version}";
  gemName = "vagrant";
  inherit version;

  doCheck = true;
  dontBuild = false;
  src = fetchurl { inherit url sha256; };

  patches = [
    ./unofficial-installation-nowarn.patch
  ];

  # PATH additions:
  #   - libarchive: Make `bsdtar` available for extracting downloaded boxes
  postInstall = ''
    wrapProgram "$out/bin/vagrant" \
      --set GEM_PATH "${deps}/lib/ruby/gems/${ruby.version.libDir}" \
      --prefix PATH ':' "${lib.getBin libarchive}/bin"
  '';

  passthru = {
    inherit ruby deps;
  };

  meta = with lib; {
    description = "A tool for building complete development environments";
    homepage = https://www.vagrantup.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ aneeshusa ];
    platforms = with platforms; linux ++ darwin;
  };
}
