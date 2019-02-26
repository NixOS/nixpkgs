[
  {
    goPackagePath = "github.com/prometheus/client_golang";
    fetch = {
      type = "git";
      url = "https://github.com/prometheus/client_golang";
      rev = "v0.9.2";
      sha256 = "02b4yg6rfag0m3j0i39sillcm5xczwv8h133vn12yr8qw04cnigs";
    };
  }
  {
    goPackagePath = "github.com/prometheus/client_model";
    fetch = {
      type = "git";
      url = "https://github.com/prometheus/client_model";
      rev = "56726106282f1985ea77d5305743db7231b0c0a8"; # https://github.com/prometheus/client_golang/blob/master/go.mod
      sha256 = "19y4qs9mkxiiab5sh3b7cccjpl3xbp6sy8812ig9f1zg8vzkzj7j";
    };
  }
  {
    goPackagePath = "github.com/prometheus/common";
    fetch = {
      type = "git";
      url = "https://github.com/prometheus/common";
      rev = "v0.2.0";                                   # https://github.com/prometheus/client_golang/blob/master/go.mod
      sha256 = "02kym6lcfnlq23qbv277jr0q1n7jj0r14gqg93c7wn7gc44jv3vp";
    };
  }
  {
    goPackagePath = "github.com/prometheus/procfs";
    fetch = {
      type = "git";
      url = "https://github.com/prometheus/procfs";
      rev = "bf6a532e95b1f7a62adf0ab5050a5bb2237ad2f4"; # https://github.com/prometheus/client_golang/blob/master/go.mod
      sha256 = "0k65i2ikf3jp6863mpc1raf928i78r8jd7zn9djx6f4izls6l6j1";
    };
  }
  {
    goPackagePath = "github.com/dgraph-io/dgo";
    fetch = {
      type = "git";
      url = "https://github.com/dgraph-io/dgo";
      rev = "3f4532227efc35d393855663e8f4166cadb1e5f0"; # 2019-01-09
      sha256 = "1vl1w3jkipd86y1ll332jq7s7n4xrxk25qclv1is76107i6pkcwn";
    };
  }
  {
    goPackagePath = "google.golang.org/grpc";
    fetch = {
      type = "git";
      url = "https://github.com/grpc/grpc-go";
      rev = "v1.13.0";
      sha256 = "0d8vj372ri55mrqfc0rhjl3albp5ykwfjhda1s5cgm5n40v70pr3";
    };
  }
  {
    goPackagePath = "google.golang.org/genproto";
    fetch = {
      type = "git";
      url = "https://github.com/google/go-genproto";
      rev = "1e559d0a00eef8a9a43151db4665280bd8dd5886";
      sha256 = "1dfm8zd9mif1aswks79wgyi7n818s5brbdnnrrlg79whfhaf20hd";
    };
  }
  {
    goPackagePath = "google.golang.org/api";
    fetch = {
      type = "git";
      url = "https://github.com/googleapis/google-api-go-client";
      rev = "v0.1.0";
      sha256 = "1az6n10i35ls13wry20nnm5afzr3j3s391nia8ghgx5vfskgzn56";
    };
  }
  {
    goPackagePath  = "go.opencensus.io";
    fetch = {
      type = "git";
      url = "https://github.com/census-instrumentation/opencensus-go";
      rev =  "v0.19.0";
      sha256 = "1z4yrwshfanab955p6f9pprb2d2cqy4xrfipc5nxhmi51spra415";
    };
  }
  {
    goPackagePath = "github.com/dgrijalva/jwt-go";
    fetch = {
      type = "git";
      url = "https://github.com/dgrijalva/jwt-go";
      rev = "v3.2.0";
      sha256 = "08m27vlms74pfy5z79w67f9lk9zkx6a9jd68k3c4msxy75ry36mp";
    };
  }
  {
    goPackagePath = "github.com/google/uuid";
    fetch = {
      type = "git";
      url = "https://github.com/google/uuid";
      rev = "v1.1.0";
      sha256 = "0yx4kiafyshdshrmrqcf2say5mzsviz7r94a0y1l6xfbkkyvnc86";
    };
  }
  {
    goPackagePath = "github.com/golang/protobuf";
    fetch = {
      type = "git";
      url = "https://github.com/golang/protobuf";
      rev = "882cf97a83ad205fd22af574246a3bc647d7a7d2";
      sha256 = "0ppsq7aw8ayrzd4hz7d3fh9wg5wrlc0rcy7majz8jvygw5h7h5lp";
    };
  }
  {
    goPackagePath = "golang.org/x/net";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/net";
      rev = "adae6a3d119ae4890b46832a2e88a95adc62b8e7";
      sha256 = "1fx860zsgzqk28j7lmp96qsfrgb0kzbfjvr294hywswcbwdwkb01";
    };
  }
  {
    goPackagePath = "golang.org/x/sync";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/sync";
      rev = "37e7f081c4d4c64e13b10787722085407fe5d15f";
      sha256 = "1bb0mw6ckb1k7z8v3iil2qlqwfj408fvvp8m1cik2b46p7snyjhm";
    };
  }
]
