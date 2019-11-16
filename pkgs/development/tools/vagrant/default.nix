{ stdenv, lib, fetchurl, buildRubyGem, bundlerEnv, ruby, libarchive
, libguestfs, qemu, writeText, withLibvirt ? stdenv.isLinux }:

let
  # NOTE: bumping the version and updating the hash is insufficient;
  # you must use bundix to generate a new gemset.nix in the Vagrant source.
  version = "2.2.5";
  url = "https://github.com/hashicorp/vagrant/archive/v${version}.tar.gz";
  sha256 = "0a228f5185b24b72efcc5a3924f86fa9fabab6f7562c3c63c1d9d239aa72a7b1";

  deps = bundlerEnv rec {
    name = "${pname}-${version}";
    pname = "vagrant";
    inherit version;

    inherit ruby;
    gemfile = writeText "Gemfile" "";
    lockfile = writeText "Gemfile.lock" "";
    gemset = lib.recursiveUpdate (import ./gemset.nix) ({
      vagrant = {
        source = {
          type = "url";
          inherit url sha256;
        };
        inherit version;
      };
    } // lib.optionalAttrs withLibvirt (import ./gemset_libvirt.nix));
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
    ./use-system-bundler-version.patch
    ./0004-Support-system-installed-plugins.patch
  ];

  postPatch = ''
    substituteInPlace lib/vagrant/plugin/manager.rb --subst-var-by \
      system_plugin_dir "$out/vagrant-plugins"
  '';

  # PATH additions:
  #   - libarchive: Make `bsdtar` available for extracting downloaded boxes
  # withLibvirt only:
  #   - libguestfs: Make 'virt-sysprep' available for 'vagrant package'
  #   - qemu: Make 'qemu-img' available for 'vagrant package'
  postInstall =
    let
      pathAdditions = lib.makeSearchPath "bin"
        (map (x: lib.getBin x) ([
          libarchive
        ] ++ lib.optionals withLibvirt [
          libguestfs
          qemu
        ]));
    in ''
    wrapProgram "$out/bin/vagrant" \
      --set GEM_PATH "${deps}/lib/ruby/gems/${ruby.version.libDir}" \
      --prefix PATH ':' ${pathAdditions}

    mkdir -p "$out/vagrant-plugins/plugins.d"
    echo '{}' > "$out/vagrant-plugins/plugins.json"

    mkdir -p $out/share/bash-completion/completions/
    cp -av contrib/bash/completion.sh $out/share/bash-completion/completions/vagrant
  '' +
  lib.optionalString withLibvirt ''
    substitute ${./vagrant-libvirt.json.in} $out/vagrant-plugins/plugins.d/vagrant-libvirt.json \
      --subst-var-by ruby_version ${ruby.version} \
      --subst-var-by vagrant_version ${version}
  '';

  installCheckPhase = ''
    if [[ "$("$out/bin/vagrant" --version)" == "Vagrant ${version}" ]]; then
      echo 'Vagrant smoke check passed'
    else
      echo 'Vagrant smoke check failed'
      return 1
    fi
  '';

  # `patchShebangsAuto` patches this one script which is intended to run
  # on foreign systems.
  postFixup = ''
    sed -i -e '1c#!/bin/sh -' \
      $out/lib/ruby/gems/*/gems/vagrant-*/plugins/provisioners/salt/bootstrap-salt.sh
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
