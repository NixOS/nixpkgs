{ stdenv, fetchurl, readline, deepin }:

let
  version = "1.5c";
in stdenv.mkDerivation rec {
  name = "zssh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zssh/${name}.tgz";
    sha256 = "06z73iq59lz8ibjrgs7d3xl39vh9yld1988yx8khssch4pw41s52";
  };

  buildInputs = [ readline ];

  patches = [
    # Cargo-culted from Arch, returns “out of pty's” without it
    (fetchurl {
      name = "fix_use_ptmx_on_arch.patch";
      url = https://git.archlinux.org/svntogit/community.git/plain/trunk/fix_use_ptmx_on_arch.patch?h=packages/zssh&id=0a7c92543f9309856d02e31196f06d7c3eaa8b67;
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
    homepage = http://zssh.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = deepin.deepin-terminal.meta.maintainers; # required by deepin-terminal
    platforms = stdenv.lib.platforms.linux;
  };
}
