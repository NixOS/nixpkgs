{ lib, stdenv, fetchhg, cmake, pkgconfig, symlinkJoin,
  xercesc, libxmlxx, guile_2_2, unixODBC, python36, libjack2 }:
# Build instructions: https://relational-pipes.globalcode.info/v_0/release-v0.16.xhtml
# Things not yet done: bash completion
let
  mkRelPipe = { pname, hash, deps }:
    stdenv.mkDerivation rec {
      name = "relpipe-${pname}";
      version = "0.16";

      src = fetchhg {
        url = "https://hg.globalcode.info/relpipe/relpipe-${pname}.cpp";
        rev = "v${version}";
        sha256 = hash;
      };

      buildInputs = deps;
      nativeBuildInputs = [ cmake pkgconfig ];

      cmakeFlags = [ "-DPROJECT_VERSION=${version}" ];

      meta = {
        maintainers = [ stdenv.lib.maintainers.MostAwesomeDude ];
        homepage = https://relational-pipes.globalcode.info/;
        license = stdenv.lib.licenses.gpl3;
        description = "An open data format designed for streaming structured data between two processes";
      };
    };

  # Our ordering here loosely follows upstream build order, but Nix frees us
  # from following it strictly.
  lib-common = mkRelPipe {
    pname = "lib-common";
    hash = "1g0ygs8k6ydxmkhncd1xpsm4yxcy90pja0iddywlgvd5jcmkjznj";
    deps = [];
  };
  lib-reader = mkRelPipe {
    pname = "lib-reader";
    hash = "09qq16bmj2im5509yar1slqgwfy7s6anq7k7xmjq9ffng53f9sdk";
    deps = [ lib-common ];
  };
  lib-writer = mkRelPipe {
    pname = "lib-writer";
    hash = "1hvazfg42808zjik4ma27d560f43d94dcpr1z9i0bz07kmvfwald";
    deps = [ lib-common ];
  };
  lib-cli = mkRelPipe {
    pname = "lib-cli";
    hash = "1clg2sapjwvf04njfl0g5gg0bj18w4rdcxqf6c04hnc766d1ii3h";
    deps = [];
  };
  lib-xmlwriter = mkRelPipe {
    pname = "lib-xmlwriter";
    hash = "03knmfq9zhxlh1nw0q6clfyr9bgcx9xpcr35rb60l7lpmz6rd998";
    deps = [];
  };

  in-fstab = mkRelPipe {
    pname = "in-fstab";
    hash = "04b8byrz0zmhw81r6595nmxb62z1p7iy1y295xk0l1in9959l940";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-cli = mkRelPipe {
    pname = "in-cli";
    hash = "1fvmdbcb0fz055345w6ynydcnnajrd3080rxwz8iz6n5pyh21ipr";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-xml = mkRelPipe {
    pname = "in-xml";
    hash = "0qcm9p7z0c4gkc6hcxbk21b5srzyl8a9f72bxjsgy0f701l4l6hi";
    deps = [ lib-cli lib-common lib-writer xercesc ];
  };
  in-xmltable = mkRelPipe {
    pname = "in-xmltable";
    hash = "08jyrlml3x8rxw2r0my69kq384xqqda17sy7sip0fdswdzh5jxih";
    deps = [ lib-cli lib-common lib-writer libxmlxx ];
  };
  in-csv = mkRelPipe {
    pname = "in-csv";
    hash = "1jzhypwank5aza2zvy130jvqhazkakpaifhd4p7k2g7lr6vbhyir";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-recfile = mkRelPipe {
    pname = "in-recfile";
    hash = "069bq4awxqih8zdbiypcrhh7zj16zb12ynpljw5axri230lml04n";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-filesystem = mkRelPipe {
    pname = "in-filesystem";
    hash = "0hsjwhq5p85z51qkk35j9szm7amnfgz9yxgqganr5xykhaclkm2n";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-jack = mkRelPipe {
    pname = "in-jack";
    hash = "0l9cz9i19wxa8ks45h52r0vgrcab6ibvvkpn2fnazy07yz5cz55b";
    deps = [ lib-cli lib-common lib-writer libjack2 ];
  };

  tr-cut = mkRelPipe {
    pname = "tr-cut";
    hash = "1cg1lmby2fpxdmwig8raf1jhcpr2374xkbic76jl3pcmmrw41zpq";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };
  tr-grep = mkRelPipe {
    pname = "tr-grep";
    hash = "0n7mkpw9q3ymmpv32fdjx8hd5wzh7q6ng2bzxvf9wh1b68f26ys2";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };
  tr-sed = mkRelPipe {
    pname = "tr-sed";
    hash = "00vpbh6hfcrszv3xh8pla2grjyddc6dcwwlpj2d9mc133pcgv52z";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };
  tr-awk = mkRelPipe {
    pname = "tr-awk";
    hash = "1q833x29ygfbw5xpqbfdj03nbl5iaqk72blkn5nc35zqag811nan";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };
  tr-guile = mkRelPipe {
    pname = "tr-guile";
    hash = "0aj5v8z07gzfs15gm3216fgb18bf36z6yh01n56mhpr9i7qwwp0q";
    deps = [ lib-cli lib-common lib-reader lib-writer guile_2_2 ];
  };
  tr-sql = mkRelPipe {
    pname = "tr-sql";
    hash = "0jxmdvfsc27644ra6xyh3b1bfa0h5z831a9riw8fxrdi4d2rv5cn";
    deps = [ lib-cli lib-common lib-reader lib-writer unixODBC ];
  };
  tr-python = mkRelPipe {
    pname = "tr-python";
    hash = "0vkhk8zfimzvzfq42q4b9pf204r19j3y49pf5x4cs1qhqzyvzj4s";
    deps = [ lib-cli lib-common lib-reader lib-writer python36 ];
  };
  tr-validator = mkRelPipe {
    pname = "tr-validator";
    hash = "0qs892ja6r1cnf1yc9x79lahnqjh58c0csz9gwdfc9y7hp8ry4ps";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };

  out-nullbyte = mkRelPipe {
    pname = "out-nullbyte";
    hash = "0lc69vnphdwpkni1yg6d3qlg3mxx626vl8z133nj9gs5z7x3zax8";
    deps = [ lib-cli lib-common lib-reader ];
  };
  out-ods = mkRelPipe {
    pname = "out-ods";
    hash = "0n3imgvid07h82sxifbvsv3gi89p4pv78kf73g2x4yifbqckybc5";
    deps = [ lib-cli lib-common lib-reader lib-xmlwriter ];
  };
  out-tabular = mkRelPipe {
    pname = "out-tabular";
    hash = "0jkj8mn32gd5ckmjp76c68ik4j0md6qbvbff59wghfpy7n69y7fh";
    deps = [ lib-cli lib-common lib-reader ];
  };
  out-xml = mkRelPipe {
    pname = "out-xml";
    hash = "1m3glydgfyx74caj9igfiry5k6lb3mdf57aw41mwq4s4hihqgfk4";
    deps = [ lib-cli lib-common lib-reader lib-xmlwriter ];
  };
  out-csv = mkRelPipe {
    pname = "out-csv";
    hash = "0p0piafdin8n1kdbjlwvygy49ml6rjh13v44k8az954vybg2zfp9";
    deps = [ lib-cli lib-common lib-reader ];
  };
  out-asn1 = mkRelPipe {
    pname = "out-asn1";
    hash = "16a8n65q5f9kwsbcpx88crrg7bz4j3aysx2g5if3k3f7vgxb2x7k";
    deps = [ lib-cli lib-common lib-reader ];
  };
  out-recfile = mkRelPipe {
    pname = "out-recfile";
    hash = "0kd2jd0xr1cffcjw048lf2hlb2s8ki3g6iarsnsvfrvlrzb6a0d4";
    deps = [ lib-cli lib-common lib-reader ];
  };
in symlinkJoin {
  name = "relpipe";
  paths = [
    in-fstab in-cli in-xml in-xmltable in-csv in-recfile in-filesystem in-jack
    tr-cut tr-grep tr-sed tr-awk tr-guile tr-sql tr-python tr-validator
    out-nullbyte out-ods out-tabular out-xml out-csv out-asn1 out-recfile
  ];
}
