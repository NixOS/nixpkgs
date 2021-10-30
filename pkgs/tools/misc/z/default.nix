{ fetchFromGitHub, lib, stdenv }:
  stdenv.mkDerivation
    { pname = "z";
      version = "1622481819";
      # ^ there isn't a version, so the UNIX time of the commit is used

      src =
        fetchFromGitHub
          { owner = "rupa";
            repo = "z";
            rev = "b82ac78a2d4457d2ca09973332638f123f065fd1";
            sha256 = "0phk9lswwxsypchb11qsnxy1pv5xg1zkrqj8im6x2icma63hfcz2";
          };

      phases = [ "unpackPhase" "installPhase" ];

      installPhase =
        ''
        mkdir -p $out/share/man/man1
        cp z.1 $out/share/man/man1
        cp z.sh $out
        # ^ for use in the module
        '';

      meta =
        let l = lib; in
        { description = "A simple cd-like command that makes it very easy to go to any location you've cd'd to in the past";

          longDescription =
            ''
            Tracks your most used directories, based on 'frecency'.

            After  a  short  learning  phase, z will take you to the most 'frecent'
            directory that matches ALL of the regexes given on the command line, in
            order.

            For example, z foo bar would match /foo/bar but not /bar/foo.
            '';

          homepage = "https://github.com/rupa/z";
          license = l.licenses.wtfpl;
          platforms = l.platforms.all;
          maintainers = [ l.maintainers.ursi ];
        };
    }
