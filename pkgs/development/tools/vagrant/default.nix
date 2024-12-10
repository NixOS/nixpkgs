{
  stdenv,
  lib,
  fetchurl,
  buildRubyGem,
  bundlerEnv,
  ruby,
  libarchive,
  libguestfs,
  qemu,
  writeText,
  withLibvirt ? stdenv.isLinux,
  openssl,
}:

let
  # NOTE: bumping the version and updating the hash is insufficient;
  # you must use bundix to generate a new gemset.nix in the Vagrant source.
  version = "2.4.1";
  url = "https://github.com/hashicorp/vagrant/archive/v${version}.tar.gz";
  hash = "sha256-Gc+jBuP/rl3b8wUE9hoaMSSqmodyGxMKFAmNTqH+v4k=";

  deps = bundlerEnv rec {
    name = "${pname}-${version}";
    pname = "vagrant";
    inherit version;

    inherit ruby;
    gemfile = writeText "Gemfile" "";
    lockfile = writeText "Gemfile.lock" "";
    gemset = lib.recursiveUpdate (import ./gemset.nix) (
      {
        vagrant = {
          source = {
            type = "url";
            inherit url hash;
          };
          inherit version;
        };
      }
      // lib.optionalAttrs withLibvirt (import ./gemset_libvirt.nix)
    );

    # This replaces the gem symlinks with directories, resolving this
    # error when running vagrant (I have no idea why):
    # /nix/store/p4hrycs0zaa9x0gsqylbk577ppnryixr-vagrant-2.2.6/lib/ruby/gems/2.6.0/gems/i18n-1.1.1/lib/i18n/config.rb:6:in `<module:I18n>': uninitialized constant I18n::Config (NameError)
    postBuild = ''
      for gem in "$out"/lib/ruby/gems/*/gems/*; do
        cp -a "$gem/" "$gem.new"
        rm "$gem"
        # needed on macOS, otherwise the mv yields permission denied
        chmod +w "$gem.new"
        mv "$gem.new" "$gem"
      done
    '';
  };

in
buildRubyGem rec {
  name = "${gemName}-${version}";
  gemName = "vagrant";
  inherit version;

  doInstallCheck = true;
  dontBuild = false;
  src = fetchurl { inherit url hash; };

  # Some reports indicate that some connection types, particularly
  # WinRM, suffer from "Digest initialization failed" errors. Adding
  # openssl as a build input resolves this runtime error.
  buildInputs = [ openssl ];

  patches = [
    ./unofficial-installation-nowarn.patch
    ./use-system-bundler-version.patch
    ./0004-Support-system-installed-plugins.patch
    ./0001-Revert-Merge-pull-request-12225-from-chrisroberts-re.patch
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
      pathAdditions = lib.makeSearchPath "bin" (
        map (x: lib.getBin x) (
          [
            libarchive
          ]
          ++ lib.optionals withLibvirt [
            libguestfs
            qemu
          ]
        )
      );
    in
    ''
      wrapProgram "$out/bin/vagrant" \
        --set GEM_PATH "${deps}/lib/ruby/gems/${ruby.version.libDir}" \
        --prefix PATH ':' ${pathAdditions} \
        --set-default VAGRANT_CHECKPOINT_DISABLE 1

      mkdir -p "$out/vagrant-plugins/plugins.d"
      echo '{}' > "$out/vagrant-plugins/plugins.json"

      # install bash completion
      mkdir -p $out/share/bash-completion/completions/
      cp -av contrib/bash/completion.sh $out/share/bash-completion/completions/vagrant
      # install zsh completion
      mkdir -p $out/share/zsh/site-functions/
      cp -av contrib/zsh/_vagrant $out/share/zsh/site-functions/
    ''
    + lib.optionalString withLibvirt ''
      substitute ${./vagrant-libvirt.json.in} $out/vagrant-plugins/plugins.d/vagrant-libvirt.json \
        --subst-var-by ruby_version ${ruby.version} \
        --subst-var-by vagrant_version ${version}
    '';

  installCheckPhase = ''
    HOME="$(mktemp -d)" $out/bin/vagrant init --output - > /dev/null
  '';

  passthru = {
    inherit ruby deps;
  };

  meta = with lib; {
    description = "A tool for building complete development environments";
    homepage = "https://www.vagrantup.com/";
    license = licenses.bsl11;
    maintainers = with maintainers; [ tylerjl ];
    platforms = with platforms; linux ++ darwin;
  };
}
