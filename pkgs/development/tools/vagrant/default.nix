{ lib, buildRubyGem, bundlerEnv, ruby, libarchive }:


# To update vagrant, visit the Gemfile and re-run bundix.

let
  gemset = import ./gemset.nix;
  inherit (gemset.vagrant) version;

  deps = bundlerEnv rec {
    name = "vagrant-${version}";
    pname = "vagrant";
    inherit version;

    inherit ruby;
    gemdir = ./.;
  };

in buildRubyGem rec {
  name = "${gemName}-${version}";
  gemName = "vagrant";

  doInstallCheck = true;
  dontBuild = false;

  inherit (deps.gems.vagrant) src;

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
