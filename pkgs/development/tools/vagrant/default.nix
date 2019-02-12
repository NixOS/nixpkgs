{ lib, fetchurl, buildRubyGem, bundlerEnv, ruby, libarchive, libguestfs, qemu, writeText, withLibvirt ? true}:

let
  # NOTE: bumping the version and updating the hash is insufficient;
  # you must use bundix to generate a new gemset.nix in the Vagrant source.
  version = "2.2.0";
  url = "https://github.com/hashicorp/vagrant/archive/v${version}.tar.gz";
  sha256 = "1wa8l3j6hpy0m0snz7wvfcf0wsjikp22c2z29crpk10f7xl7c56b";

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
        (map (x: "${lib.getBin x}") ([
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
