{ stdenv, lib, go, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  name = "the_platinum_searcher-${version}";
  version = "2.1.1";
  rev = "v2.1.1";

  buildInputs = [ go go-flags ansicolor text toml yaml-v2 ];

  goPackagePath = "github.com/monochromegane/the_platinum_searcher";

  src = fetchFromGitHub {
    inherit rev;
    owner = "monochromegane";
    repo = "the_platinum_searcher";
    sha256 = "06cs936w3l64ikszcysdm9ijn52kwgi1ffjxkricxbdb677gsk23";
  };

  extraSrcs = [
    {
      goPackagePath = "github.com/monochromegane/conflag";

      src = fetchFromGitHub {
        owner = "monochromegane";
        repo = "conflag";
        rev = "6d68c9aa4183844ddc1655481798fe4d90d483e9";
        sha256 = "0csfr5c8d3kbna9sqhzfp2z06wq6mc6ijja1zj2i82kzsq8534wa";
      };
    }
    {
      goPackagePath = "github.com/monochromegane/go-gitignore";

      src = fetchFromGitHub {
        owner = "monochromegane";
        repo = "go-gitignore";
        rev = "38717d0a108ca0e5af632cd6845ca77d45b50729";
        sha256 = "0r1inabpgg6sn6i47b02hcmd2p4dc1ab1mcy20mn1b2k3mpdj4b7";
      };
    }
    {
      goPackagePath = "github.com/monochromegane/go-home";

      src = fetchFromGitHub {
        owner = "monochromegane";
        repo = "go-home";
        rev = "25d9dda593924a11ea52e4ffbc8abdb0dbe96401";
        sha256 = "172chakrj22xfm0bcda4qj5zqf7lwr53pzwc3xj6wz8vd2bcxkww";
      };
    }
    {
      goPackagePath = "github.com/monochromegane/terminal";

      src = fetchFromGitHub {
        owner = "monochromegane";
        repo = "terminal";
        rev = "2da212063ce19aed90ee5bbb00ad1ad7393d7f48";
        sha256 = "1rddaq9pk5q57ildms35iihghqk505gb349pb0f6k3svchay38nh";
      };
    }
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/monochromegane/the_platinum_searcher;
    description = "A code search tool similar to ack and the_silver_searcher(ag).";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
