{ lib, fetchurl, buildRubyGem, bundlerEnv, ruby, libarchive }:

let
  version = "2.0.2";
  url = "https://github.com/hashicorp/vagrant/archive/v${version}.tar.gz";
  sha256 = "1sjfwgy2y6q5s1drd8h8xgz2a0sv1l3kx9jilgc02hlcdz070iir";

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

  doInstallCheck = true;
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

  installCheckPhase = ''
    if [[ "$("$out/bin/vagrant" --version)" == "Vagrant ${version}" ]]; then
      echo 'Vagrant smoke check passed'
    else
      echo 'Vagrant smoke check failed'
      return 1
    fi
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
