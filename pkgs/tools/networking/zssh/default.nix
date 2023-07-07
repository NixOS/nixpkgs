{ lib, stdenv, fetchurl, readline }:

let
  version = "1.5c";
in stdenv.mkDerivation rec {
  pname = "zssh";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/zssh/${pname}-${version}.tgz";
    sha256 = "06z73iq59lz8ibjrgs7d3xl39vh9yld1988yx8khssch4pw41s52";
  };

  buildInputs = [ readline ];

  patches = [
    # Cargo-culted from Arch, returns “out of pty's” without it
    (fetchurl {
      name = "fix_use_ptmx_on_arch.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/0a7c92543f9309856d02e31196f06d7c3eaa8b67/trunk/fix_use_ptmx_on_arch.patch";
      sha256 = "12daw9wpy58ql882zww945wk9cg2adwp8qsr5rvazx0xq0qawgbr";
    })
  ];

  patchFlags = [ "-p0" ];

  # The makefile does not create the directories
  postBuild = ''
    install -dm755 "$out"/{bin,man/man1}
  '';

  meta = {
    description = "SSH and Telnet client with ZMODEM file transfer capability";
    homepage = "https://zssh.sourceforge.net/";
    license = lib.licenses.gpl2;
    maintainers = [ ]; # required by deepin-terminal
    platforms = lib.platforms.linux;
  };
}
