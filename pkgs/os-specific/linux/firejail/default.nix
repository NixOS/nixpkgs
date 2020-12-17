{stdenv, fetchurl, fetchpatch, which, xdg-dbus-proxy, nixosTests}:
let
  s = # Generated upstream information
  rec {
    baseName="firejail";
    version="0.9.64";
    name="${baseName}-${version}";
    url="mirror://sourceforge/firejail/firejail/firejail-${version}.tar.xz";
    sha256="1zgjwy2k57nx0r63fzr15gijah098ig0bll66jd615vc9q3snfz5";
  };
  buildInputs = [
    which
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
    name = "${s.name}.tar.bz2";
  };

  patches = [
    # Adds the /nix directory when using an overlay.
    # Required to run any programs under this mode.
    ./mount-nix-dir-on-overlay.patch
    # By default fbuilder hardcodes the firejail binary to the install path.
    # On NixOS the firejail binary is a setuid wrapper available in $PATH.
    ./fbuilder-call-firejail-on-path.patch
  ];

  prePatch = ''
    # Allow whitelisting ~/.nix-profile
    substituteInPlace etc/firejail.config --replace \
      '# follow-symlink-as-user yes' \
      'follow-symlink-as-user no'

    # Fix the path to 'xdg-dbus-proxy' hardcoded in the 'common.h' file
    substituteInPlace src/include/common.h \
      --replace '/usr/bin/xdg-dbus-proxy' '${xdg-dbus-proxy}/bin/xdg-dbus-proxy'
  '';

  preConfigure = ''
    sed -e 's@/bin/bash@${stdenv.shell}@g' -i $( grep -lr /bin/bash .)
    sed -e "s@/bin/cp@$(which cp)@g" -i $( grep -lr /bin/cp .)
  '';

  preBuild = ''
    sed -e "s@/etc/@$out/etc/@g" -e "/chmod u+s/d" -i Makefile
  '';

  # The profile files provided with the firejail distribution include `.local`
  # profile files using relative paths. The way firejail works when it comes to
  # handling includes is by looking target files up in `~/.config/firejail`
  # first, and then trying `SYSCONFDIR`. The latter normally points to
  # `/etc/filejail`, but in the case of nixos points to the nix store. This
  # makes it effectively impossible to place any profile files in
  # `/etc/firejail`.
  #
  # The workaround applied below is by creating a set of `.local` files which
  # only contain respective includes to `/etc/firejail`. This way
  # `~/.config/firejail` still takes precedence, but `/etc/firejail` will also
  # be searched in second order. This replicates the behaviour from
  # non-nixos platforms.
  #
  # See https://github.com/netblue30/firejail/blob/e4cb6b42743ad18bd11d07fd32b51e8576239318/src/firejail/profile.c#L68-L83
  # for the profile file lookup implementation.
  postInstall = ''
    for local in $(grep -Eh '^include.*local$' $out/etc/firejail/*.profile | awk '{print $2}' | sort | uniq)
    do
      echo "include /etc/firejail/$local" >$out/etc/firejail/$local
    done
  '';

  # At high parallelism, the build sometimes fails with:
  # bash: src/fsec-optimize/fsec-optimize: No such file or directory
  enableParallelBuilding = false;

  passthru.tests = nixosTests.firejail;

  meta = {
    inherit (s) version;
    description = ''Namespace-based sandboxing tool for Linux'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://firejail.wordpress.com/";
    downloadPage = "https://sourceforge.net/projects/firejail/files/firejail/";
  };
}
