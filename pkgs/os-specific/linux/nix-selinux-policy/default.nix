{ stdenv, checkpolicy, semodule-utils }:

stdenv.mkDerivation rec {
  name = "nix-selinux-policy-${version}";
  version = "1.0";

  srcs = [./nix.te ./nix.fc];

  buildInputs = [ checkpolicy semodule-utils ];
  unpackPhase = "true";
  buildPhase = ''
    mkdir -p $out
    checkmodule -M -m -o $TMPDIR/nix.mod ${./nix.te}
    semodule_package -o $out/nix.pp -m $TMPDIR/nix.mod -f ${./nix.fc}
  '';
  installPhase = "true";

  meta = with stdenv.lib; {
    description = "Nix Store SELinux Policy";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.e-user ];
  };
}
