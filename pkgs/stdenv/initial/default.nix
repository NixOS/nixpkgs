# Here we construct an absolutely trivial `initial' standard
# environment.  It's not actually a functional stdenv, since there is
# not necessarily a working C compiler.  We need this to build
# gcc-wrapper et al. for the native stdenv.

{system, name}:

let {

  body = 

    derivation {
      inherit system name;
      builder = "/bin/sh";
      args = ["-e" ./builder.sh];
    }

    // {
      mkDerivation = attrs: derivation (attrs // {
        builder = "/bin/sh";
        args = ["-e" attrs.builder];
        stdenv = body;
        system = body.system;
      });
    };

}
