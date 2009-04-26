{stdenv, fetchurl, readline ? null, interactive ? false, texinfo ? null, bison}:

assert interactive -> readline != null;

stdenv.mkDerivation rec {
  name = "bash-4.0-p17";

  src = fetchurl {
    url = "mirror://gnu/bash/bash-4.0.tar.gz";
    sha256 = "0605ql0ih55gpi0vfvcm45likzjafa4wjnkxqwq51aa0ysad74wp";
  };

  NIX_CFLAGS_COMPILE = ''
    -DSYS_BASHRC="/etc/bashrc"
    -DSYS_BASH_LOGOUT="/etc/bash_logout"
    -DDEFAULT_PATH_VALUE="/no-such-path"
    -DSTANDARD_UTILS_PATH="/no-such-path"
    -DNON_INTERACTIVE_LOGIN_SHELLS
    -DSSH_SOURCE_BASHRC
  '';

  postInstall = "ln -s bash $out/bin/sh";

  patchFlags = "-p0";

  patches =
    let
      patch = nr: sha256:
        fetchurl {
          url = "mirror://gnu/bash/bash-4.0-patches/bash40-${nr}";
          inherit sha256;
        };
    in [
      (patch "001" "06q3y3i2kp09bnjd99lxa95psdmj2haril7pxhdbz9sx9qh19dg3")
      (patch "002" "1x2w3mmz1qga30zf95wmnpjsdp8cnd2ljl29mfq9r6q1cvjifla9")
      (patch "003" "1n3vg6p4nc7kd896s0fp48y9f6ddf3bkpdqzgmdpgqxi243c8073")
      (patch "004" "1bnja962g9isrqhrw8dzxsx7ssvc2ayk1a9vmg2dx6gai8gys0sb")
      (patch "005" "0l4l62riap2kqy20789x7f6bfx361yvixds0gnh10rli4v05h1j2")
      (patch "006" "1r429n2b5cs2gi5zjv1hlr8k7jplnjg3y563369z799x1x9651y7")
      (patch "007" "0vb11vy8r5ayr88hrlli8xj2qcird1qg8l99nknrwnni4jg5b3am")
      (patch "008" "1z6q0lq1yxwpf6nf1z39jbyycv6cfv6gwpaqmgg7pnw31z029nw7")
      (patch "009" "0avyvz8rkj66x715zf1b3w2pgbwwzaj977v9pcrscjksc50c4iq0")
      (patch "010" "05j8xq2s1wnii1za1s6nglzga9xp7q1dmcs1bqqrlggz8mmnyhgj")
      (patch "011" "1m2lhfhy6bl3j88qi9kcn6n1qb439n8pmhl4cqsmi2g8xwli9j7z")
      (patch "012" "1ww327ga4s7607jgr0xd6nh8bg4xgf2vk63p2yy9b1iaq7lxdi5j")
      (patch "013" "0fjc3qj4q6q2zfq1qmiarp6s4hhbh80q47xwws0mvgpks7wwl33n")
      (patch "014" "16n3l7627n8b1p9s9ss9fcj7nbn1s6yndwmlh3v751knj73c9v8k")
      (patch "015" "0548fm4vd3sv3y4g3csysm1mm7jk5hvyfwglw1c0pj2lvyzf583v")
      (patch "016" "06fmf6jmgzl0x1vd7pkyi90sa1wjywkd42gi1phqmrwgj9p96flg")
      (patch "017" "08gh63spac39z90n1d8gpx571x7n4bwzp2yqm3ik9c1rcgz2mvib")
    ];

  # Note: Bison is needed because the patches above modify parse.y.
  buildInputs = [bison]
    ++ stdenv.lib.optional (texinfo != null) texinfo
    ++ stdenv.lib.optional interactive readline;

  configureFlags = "--with-installed-readline";

  meta = {
    homepage = http://www.gnu.org/software/bash/;
    description =
      "GNU Bourne-Again Shell, the de facto standard shell on Linux" +
        (if interactive then " (for interactive use)" else "");

    longDescription = ''
      Bash is the shell, or command language interpreter, that will
      appear in the GNU operating system.  Bash is an sh-compatible
      shell that incorporates useful features from the Korn shell
      (ksh) and C shell (csh).  It is intended to conform to the IEEE
      POSIX P1003.2/ISO 9945.2 Shell and Tools standard.  It offers
      functional improvements over sh for both programming and
      interactive use.  In addition, most sh scripts can be run by
      Bash without modification.
    '';

    license = "GPLv3+";
  };
}
