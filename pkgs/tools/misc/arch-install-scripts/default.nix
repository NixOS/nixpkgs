{ lib
, resholvePackage
, fetchFromGitHub
, asciidoc
, bash
, coreutils
, gawk
, gnum4
, testVersion
, util-linux
}:

resholvePackage rec {
  pname = "arch-install-scripts";
  version = "24";

  src = fetchFromGitHub {
    owner = "archlinux";
    repo = "arch-install-scripts";
    rev = "v${version}";
    sha256 = "06rydiliis34lbz5fsayhbczs1xqi1a80jnhxafpjf6k3rfji6iq";
  };

  nativeBuildInputs = [ asciidoc gnum4 ];

  preBuild = ''
    substituteInPlace ./Makefile \
      --replace "PREFIX = /usr/local" "PREFIX ?= /usr/local"

    # https://github.com/archlinux/arch-install-scripts/pull/10
    substituteInPlace ./common \
      --replace "print '%s' \"\$1\"" "printf '%s' \"\$1\""
  '';

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  solutions = {
    # Give each solution a short name. This is what you'd use to
    # override its settings, and it shows in (some) error messages.
    profile = {
      # the only *required* arguments are the 3 below

      # Specify 1 or more $out-relative script paths. Unlike many
      # builders, resholvePackage modifies the output files during
      # fixup (to correctly resolve in-package sourcing).
      scripts = [ "bin/arch-chroot" "bin/genfstab" "bin/pacstrap" ];

      # "none" for no shebang, "${bash}/bin/bash" for bash, etc.
      interpreter = "${bash}/bin/bash";

      # packages resholve should resolve executables from
      inputs = [ coreutils gawk util-linux ];
    };
  };

  meta = with lib; {
    description = "Useful scripts for installing Arch Linux";
    longDescription = ''
      A small suite of scripts aimed at automating some menial tasks when installing Arch Linux.
    '';
    homepage = "https://github.com/archlinux/arch-install-scripts";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ yayayayaka ];
    platforms = platforms.linux;
  };
}
