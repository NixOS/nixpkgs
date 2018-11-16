{ lib, fetchurl, buildRubyGem, bundlerEnv, ruby, libarchive, writeText, withLibvirt ? true, libvirt, pkgconfig }:

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

  buildInputs = lib.optional withLibvirt [ libvirt pkgconfig ];

  patches = [
    ./unofficial-installation-nowarn.patch
    ./use-system-bundler-version.patch
  ];

  # PATH additions:
  #   - libarchive: Make `bsdtar` available for extracting downloaded boxes
  postInstall = ''
    wrapProgram "$out/bin/vagrant" \
      --set GEM_PATH "${deps}/lib/ruby/gems/${ruby.version.libDir}" \
      --prefix PATH ':' "${lib.getBin libarchive}/bin" \
      ${lib.optionalString withLibvirt ''
        --prefix PATH ':' "${pkgconfig}/bin" \
        --prefix PKG_CONFIG_PATH ':' \
          "${lib.makeSearchPath "lib/pkgconfig" [ libvirt ]}"
      ''}
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
