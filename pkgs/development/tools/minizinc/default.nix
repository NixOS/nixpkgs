{ stdenv, fetchFromGitHub, fetchpatch, cmake, flex, bison }:
let
  version = "2.4.3";
in
stdenv.mkDerivation {
  pname = "minizinc";
  inherit version;

  buildInputs = [ cmake flex bison ];

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    rev = version;
    sha256 = "0mahf621zwwywimly5nd6j39j7qr48k5p7zwpfqnjq4wn010mbf8";
  };

  patches = [
    # Fix build with newer Bison versions:
    # https://github.com/MiniZinc/libminizinc/issues/389
    (fetchpatch {
      url = "https://github.com/MiniZinc/libminizinc/commit/d3136f6f198d3081943c17ac6890dbe14a81d112.diff";
      sha256 = "1f4wxn9422ndgq6dd0vqdxm2313srm7gn9nh82aas2xijdxlmz2c";
    })
    (fetchpatch {
      name = "bison-3.7-compat-1.patch";
      url = "https://github.com/MiniZinc/libminizinc/commit/8d4dcf302e78231f7c2665150e8178cacd06f91c.patch";
      sha256 = "1wgciyrqijv7b4wqha94is5skji8j7b9wq6fkdsnsimfd3xpxhqw";
    })
    (fetchpatch {
      name = "bison-3.7-compat-2.patch";
      url = "https://github.com/MiniZinc/libminizinc/commit/952ffda0bd23dc21f83d3e3f080ea5b3a414e8e0.patch";
      sha256 = "0cnsfqw0hwm7rmazqnb99725rm2vdwab75vdpr5x5l3kjwsn76rj";
    })
  ];

  meta = with stdenv.lib; {
    homepage = "https://www.minizinc.org/";
    description = "MiniZinc is a medium-level constraint modelling language.";

    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';

    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.sheenobu ];
  };
}
