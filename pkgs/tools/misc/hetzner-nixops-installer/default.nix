{ stdenv, perl, gnutar, pathsFromGraph, nix, pythonPackages }:

let
  nixpart = pythonPackages.nixpart.override {
    useNixUdev = false;
    udevSoMajor = 0;
  };

  base = stdenv.mkDerivation {
    name = "hetzner-nixops-base";

    buildCommand = ''
      ensureDir "$out/bin"
      ln -s "${nix}"/bin/* "$out/bin/"
      ln -s "${stdenv.shell}" "$out/bin/sh"
    '';
  };
in stdenv.mkDerivation {
  name = "hetzner-nixops-installer";

  exportReferencesGraph = [
    "refs-base" base
    "refs-nixpart" nixpart
  ];

  buildCommand = ''
    ensureDir "usr/bin"

    # Create the chroot wrappers for Nix
    for path in "${nix}"/bin/*; do
      base="$(basename "$path")"
      wrapper="usr/bin/$base"
      echo "#!/bin/sh" > "$wrapper"
      echo "chroot /mnt \"$path\" \$@" >> "$wrapper"
      chmod +x "$wrapper"
    done

    # Only a symlink that is goint to be put into the Tar file.
    ln -ns "${nixpart}/bin/nixpart" usr/bin/nixpart

    base_storepaths="$("${perl}/bin/perl" "${pathsFromGraph}" refs-base)"
    base_registration="$(printRegistration=1 \
      "${perl}/bin/perl" "${pathsFromGraph}" refs-base)"

    ( # Don't use stdenv.shell here, we're NOT on NixOS!
      echo "#!/bin/sh"
      # Do not quote because we want to inline the paths!
      echo 'mkdir -m 1777 -p "/mnt/nix/store"'
      echo "cp -a" $base_storepaths "/mnt/nix/store/"
      echo "chroot /mnt \"${base}/bin/nix-store\" --load-db <<'REGINFO'"
      echo "$base_registration"
      echo "REGINFO"
      echo 'ln -sn "${stdenv.shell}" /mnt/bin/sh'
    ) > "usr/bin/activate-remote"
    chmod +x "usr/bin/activate-remote"

    full_storepaths="$("${perl}/bin/perl" "${pathsFromGraph}" refs-*)"
    stripped_full_storepaths="$(echo "$full_storepaths" | sed 's|/*||')"

    # Reset timestamps to those of 'nix-store' to prevent annoying warnings.
    find usr -exec touch -h -r "${nix}/bin/nix-store" {} +

    ( echo "#!${stdenv.shell}"
      echo 'tarfile="$(mktemp)"'
      echo 'trap "rm -f $tarfile" EXIT'
      echo "lnum=\"\$(grep -m1 -an '^EXISTING_TAR${"\$"}' \"$out\")\""
      echo 'tail -n +$((''${lnum%%:*} + 1)) "'"$out"'" > "$tarfile"'
      # As before, don't quote here!
      echo '${gnutar}/bin/tar rf "$tarfile" -C /' $stripped_full_storepaths
      echo 'cat "$tarfile"'
      echo "exit 0"
      echo EXISTING_TAR
      tar c usr
    ) > "$out"
    chmod +x "$out"
  '';

  meta = {
    description = "Basic Nix bootstrap installer for NixOps";
    longDescription = ''
      It works like this:

      Preapare a base image with reference graph, which is to be copied over to
      the mount point and contains wrappers for the system outside the mount
      point. Those wrappers basically just chroot into the mountpoint path and
      execute the corresponding counterparts over there. The base derivation
      itself only contains everything necessary in order to get a Nix
      bootstrapped, like Nix itself and a shell linked to /mnt/bin/sh.

      From outside the mountpoint, we just provide a small derivation which
      contains a partitioner, an activate-remote and a script which is the
      output of this derivation. In detail:

      $out: Creates a tarball of of the full closure of the base derivation and
            its reference information, the partitioner and activate-remote. The
            script outputs the tarball on stdout, so it's easy for NixOps to
            pipe it to the remote system.

      activate-remote: Copies the base derivation into /mnt and registers it
                       with the Nix database. Afterwards, it creates the
                       mentioned chroot wrappers and puts them into /usr/bin
                       (remember, we're on a non-NixOS system here), together
                       with the partitioner.
    '';
    maintainer = stdenv.lib.maintainers.aszlig;
  };
}
