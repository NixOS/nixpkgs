{ stdenv, lib, pkgconfig, libmtp, go, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/hanwen/go-mtpfs";
      src = fetchFromGitHub {
        owner = "hanwen";
        repo = "go-mtpfs";
        rev = "9c2b46050e8ea8574eaec2124867ac7b11e6471d";
        sha256 = "0kxi18cb078q4wikfajp3yvp802wzfsfdp431j0dg2jdw8y7gfii";
      };
    }
    {
      root = "github.com/hanwen/go-fuse";
      src = fetchFromGitHub {
        owner = "hanwen";
        repo = "go-fuse";
        rev = "5d16aa11eef4643de2d91e88a64dcb6138705d58";
        sha256 = "0lycfhchn88kbs81ypz8m5jh032fpbv14gldrjirf32wm1d4f8pj";
      };
    }
    {
      root = "github.com/hanwen/usb";
      src = fetchFromGitHub {
        owner = "hanwen";
        repo = "usb";
        rev = "69aee4530ac705cec7c5344418d982aaf15cf0b1";
        sha256 = "01k0c2g395j65vm1w37mmrfkg6nm900khjrrizzpmx8f8yf20dky";
      };
    }
  ];

  sources = stdenv.mkDerivation rec {
    name = "go-deps";
    buildCommand =
      lib.concatStrings
        (map (dep: ''
                mkdir -p $out/src/`dirname ${dep.root}`
                ln -s ${dep.src} $out/src/${dep.root}
              '') goDeps);
  };
in stdenv.mkDerivation rec {
  name = "go-mtpfs";

  src = sources;

  buildInputs = [ go pkgconfig libmtp ];

  installPhase = ''
    mkdir -p $out/bin
    export GOPATH=$src
    go build -v -o $out/bin/go-mtpfs github.com/hanwen/go-mtpfs
  '';

  meta = with lib; {
    description = "A simple FUSE filesystem for mounting Android devices as a MTP device";
    homepage    = https://github.com/hanwen/go-mtpfs;
    maintainers = with maintainers; [ bennofs ];
    platforms   = platforms.linux;
    license     = licenses.bsd3;
  };
}
