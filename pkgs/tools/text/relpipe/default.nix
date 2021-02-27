{ lib, stdenv, fetchhg, cmake, pkg-config, installShellFiles, symlinkJoin,
  xercesc, libxmlxx, guile_2_2, unixODBC, python36, libjack2 }:
# Build instructions: https://relational-pipes.globalcode.info/v_0/release-v0.16.xhtml
let
  mkRelPipe = { pname, hash, deps }:
    stdenv.mkDerivation rec {
      name = "relpipe-${pname}";
      version = "0.17.1";

      src = fetchhg {
        url = "https://hg.globalcode.info/relpipe/relpipe-${pname}.cpp";
        rev = "v${version}";
        sha256 = hash;
      };

      buildInputs = deps;
      nativeBuildInputs = [ cmake pkg-config installShellFiles ];

      cmakeFlags = [ "-DPROJECT_VERSION=${version}" ];

      postInstall = ''
        if [[ -f $src/bash-completion.sh ]]; then
          installShellCompletion --bash --name ${pname}.completion.bash $src/bash-completion.sh
        fi
      '';

      meta = with lib; {
        maintainers = [ maintainers.MostAwesomeDude ];
        homepage = https://relational-pipes.globalcode.info/;
        license = licenses.gpl3;
        description = "An open data format designed for streaming structured data between two processes";
      };
    };

  # Our ordering here loosely follows upstream build order, but Nix frees us
  # from following it strictly.
  lib-common = mkRelPipe {
    pname = "lib-common";
    hash = "18s6nq0n1vn12p1akar12ki18fjp0s3y9vzs87wcdj3dk7v4z7dx";
    deps = [];
  };
  lib-reader = mkRelPipe {
    pname = "lib-reader";
    hash = "02zpd0bmzh30rki7cxjjcxpj5j5l8jsdk6i07x9vgp0d4hlhlmxl";
    deps = [ lib-common ];
  };
  lib-writer = mkRelPipe {
    pname = "lib-writer";
    hash = "02nykm924v97mib44skafj8nr1qkk8r1lfcwz4p27vahfjj9q9d0";
    deps = [ lib-common ];
  };
  lib-cli = mkRelPipe {
    pname = "lib-cli";
    hash = "1657sl6kfra5z69b9pp1pzx2glsmz8nfnjgrmvnpnxw7dvl72wiz";
    deps = [];
  };
  lib-xmlwriter = mkRelPipe {
    pname = "lib-xmlwriter";
    hash = "0rhviihy1cvbynpjpr6fdnlp12dcndidqfr589r21ykrrkmddg43";
    deps = [];
  };

  in-fstab = mkRelPipe {
    pname = "in-fstab";
    hash = "1ql13xlvjs578scnn48pj1bbs27yr4kiffd3fhnvmin2f0564yz4";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-cli = mkRelPipe {
    pname = "in-cli";
    hash = "13hjg6vb6pp9n42pmdj2k69j7xcq9hnp2h0c7ckxchsb3dc78702";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-xml = mkRelPipe {
    pname = "in-xml";
    hash = "1liwy179yr1qb031rci965359q1s3fh4gw42xf7jb8mz13ksgk14";
    deps = [ lib-cli lib-common lib-writer xercesc ];
  };
  in-xmltable = mkRelPipe {
    pname = "in-xmltable";
    hash = "19wafsihvy4gzv6ahmsdlklnggn5ijyqs5nwcrwcmn4dg6p5sccy";
    deps = [ lib-cli lib-common lib-writer libxmlxx ];
  };
  in-csv = mkRelPipe {
    pname = "in-csv";
    hash = "1pphcycr0ws8wcia9bz4p4kc67mcgqwracvpbppi2lkqsdhqdzqk";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-recfile = mkRelPipe {
    pname = "in-recfile";
    hash = "1ivgfvw9lv4788wzbf16mfp9qkmgdifxz3dsalw4zrvdih72vbx3";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-filesystem = mkRelPipe {
    pname = "in-filesystem";
    hash = "1lwy08yvq2bgxz1wzpd0ibhhpf3rj4xsw0lb1j5i3xich4cqsblj";
    deps = [ lib-cli lib-common lib-writer ];
  };
  in-jack = mkRelPipe {
    pname = "in-jack";
    hash = "1mfj1xym0jcckcbdqlgn9gmh143z06iykfpakwp3ihc0djsk2ml5";
    deps = [ lib-cli lib-common lib-writer libjack2 ];
  };

  tr-cut = mkRelPipe {
    pname = "tr-cut";
    hash = "0ikw34irv10mgngipv1i0ha670lg695srj3mgvn23z9w1z2pjsy7";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };
  tr-grep = mkRelPipe {
    pname = "tr-grep";
    hash = "0cndlwmq34b9yh4i1wpf1x8yj6mqqjq7yxh01jp6p5mm10cbyymi";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };
  tr-sed = mkRelPipe {
    pname = "tr-sed";
    hash = "1wbw5hpich788gmsy8xfpjrmi4clx1km6wrf4w0qh72vl7w64b40";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };
  tr-awk = mkRelPipe {
    pname = "tr-awk";
    hash = "1bp5wmkikmj8fwmggkjb9ka4yii1qiwy1322z4qk31xx6ma6mz17";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };
  tr-scheme = mkRelPipe {
    pname = "tr-scheme";
    hash = "1s51z7r46gqa71i66yxkymh95djxgll6g26xhigq7z19xhgdnpdh";
    deps = [ lib-cli lib-common lib-reader lib-writer guile_2_2 ];
  };
  tr-sql = mkRelPipe {
    pname = "tr-sql";
    hash = "0pivc1q9hvvai52d5xzfqlvbv1s4m3y7p6bj3pyb7kn38ga66fa3";
    deps = [ lib-cli lib-common lib-reader lib-writer unixODBC ];
  };
  tr-python = mkRelPipe {
    pname = "tr-python";
    hash = "1yq1v3i2nks45rlkld57h03ii6szfa8qim5pvh2f16ziql3xmyx4";
    deps = [ lib-cli lib-common lib-reader lib-writer python36 ];
  };
  tr-validator = mkRelPipe {
    pname = "tr-validator";
    hash = "0ac6c907aqfnmm3q3b3lcspfd430gjhzajgxay0syli5k4s1zkcc";
    deps = [ lib-cli lib-common lib-reader lib-writer ];
  };

  out-nullbyte = mkRelPipe {
    pname = "out-nullbyte";
    hash = "1nq2icfs0rxzp1vdhl9nimg5cj8w478nzkyq2d9mnq79gkrdag04";
    deps = [ lib-cli lib-common lib-reader ];
  };
  out-ods = mkRelPipe {
    pname = "out-ods";
    hash = "0i12w8cbz485v9hymhn8vxxj24cwpa0r59y2hl6m0v7mn50gnrfd";
    deps = [ lib-cli lib-common lib-reader lib-xmlwriter ];
  };
  out-tabular = mkRelPipe {
    pname = "out-tabular";
    hash = "1idvndyvq6i5wjii14pbphn79fpc6hl28qgksxyda77l2qfynnb7";
    deps = [ lib-cli lib-common lib-reader ];
  };
  out-xml = mkRelPipe {
    pname = "out-xml";
    hash = "0rc0xnc4g3wpqhdc6lfb1sagb1vl4yzvh2hd6q96jk45y037qs0c";
    deps = [ lib-cli lib-common lib-reader lib-xmlwriter ];
  };
  out-csv = mkRelPipe {
    pname = "out-csv";
    hash = "1aci7y5vfi6q6s3mqw6yzavvxjhrsinsv9qixqdgbczp3lcl3bj7";
    deps = [ lib-cli lib-common lib-reader ];
  };
  out-asn1 = mkRelPipe {
    pname = "out-asn1";
    hash = "01iazvr8qq0nbnap56zs18c3wpxaldkcffxfsp0ii6khv90yy8ka";
    deps = [ lib-cli lib-common lib-reader ];
  };
  out-recfile = mkRelPipe {
    pname = "out-recfile";
    hash = "1d9d25w0p8vlsa5n5x3k8kb9pms06r1vwanwxx45k09l2msvw7c9";
    deps = [ lib-cli lib-common lib-reader ];
  };
  out-jack = mkRelPipe {
    pname = "out-jack";
    hash = "16q9ck2qwyy8f7yqcaab1dicwav325cmajqah9q89xrlkjx3mq2j";
    deps = [ lib-cli lib-common lib-reader libjack2 ];
  };
in symlinkJoin {
  name = "relpipe";
  paths = [
    in-fstab in-cli in-xml in-xmltable in-csv in-recfile in-filesystem in-jack
    tr-cut tr-grep tr-sed tr-awk tr-scheme tr-sql tr-python tr-validator
    out-nullbyte out-ods out-tabular out-xml out-csv out-asn1 out-recfile out-jack
  ];
}
