{ lib
, resholve
, fetchFromGitHub
, asciidoc
, bash
, coreutils
, gawk
, gnugrep
, gnum4
, pacman
, util-linux
, chrootPath ? [
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/bin"
    "/usr/bin/site_perl"
    "/usr/bin/vendor_perl"
    "/usr/bin/core_perl"
  ]
}:

resholve.mkDerivation rec {
  pname = "arch-install-scripts";
  version = "28";

  src = fetchFromGitHub {
    owner = "archlinux";
    repo = "arch-install-scripts";
    rev = "v${version}";
    hash = "sha256-TytCeejhjWYDzWFjGubUl08OrsAQa9fFULoamDfbdDY=";
  };

  nativeBuildInputs = [ asciidoc gnum4 ];

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace "PREFIX = /usr/local" "PREFIX ?= /usr/local"
    substituteInPlace ./pacstrap.in \
      --replace "cp -a" "cp -LR --no-preserve=mode" \
      --replace "unshare pacman" "unshare ${pacman}/bin/pacman" \
      --replace 'gnupg "$newroot/etc/pacman.d/"' 'gnupg "$newroot/etc/pacman.d/" && chmod 700 "$newroot/etc/pacman.d/gnupg"'
    echo "export PATH=${lib.strings.makeSearchPath "" chrootPath}:\$PATH" >> ./common
  '';

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  solutions = {
    # Give each solution a short name. This is what you'd use to
    # override its settings, and it shows in (some) error messages.
    profile = {
      # the only *required* arguments are the 3 below

      # Specify 1 or more $out-relative script paths. Unlike many
      # builders, resholve.mkDerivation modifies the output files during
      # fixup (to correctly resolve in-package sourcing).
      scripts = [ "bin/arch-chroot" "bin/genfstab" "bin/pacstrap" ];

      # "none" for no shebang, "${bash}/bin/bash" for bash, etc.
      interpreter = "${bash}/bin/bash";

      # packages resholve should resolve executables from
      inputs = [ coreutils gawk gnugrep pacman util-linux ];

      execer = [ "cannot:${pacman}/bin/pacman-key" ];

      # TODO: no good way to resolve mount/umount in Nix builds for now
      # see https://github.com/abathur/resholve/issues/29
      fix = {
        mount = true;
        umount = true;
      };

      keep = [ "$setup" "$pid_unshare" "$mount_unshare" "${pacman}/bin/pacman" ];
    };
  };

  meta = with lib; {
    description = "Useful scripts for installing Arch Linux";
    longDescription = ''
      A small suite of scripts aimed at automating some menial tasks when installing Arch Linux.
    '';
    homepage = "https://github.com/archlinux/arch-install-scripts";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ samlukeyes123 ];
    platforms = platforms.linux;
  };
}
