[
  rec {
    goPackagePath = "github.com/golang/glog";
    fetch = {
      type = "git";
      url = "https://${goPackagePath}.git";
      rev = "23def4e6c14b4da8ac2ed8007337bc5eb5007998";
      sha256 = "0jb2834rw5sykfr937fxi8hxi2zy80sj2bdn9b3jb4b26ksqng30";
    };
  }
  rec {
    goPackagePath = "github.com/spf13/afero";
    fetch = {
      type = "git";
      url = "https://${goPackagePath}.git";
      rev = "5660eeed305fe5f69c8fc6cf899132a459a97064";
      sha256 = "0rpwvjp9xfmy2yvbmy810qamjhimr56zydvx7hb1gjn3b7jp4rhd";
    };
  }
  rec {
    goPackagePath = "github.com/fsnotify/fsnotify";
    fetch = {
      type = "git";
      url = "https://${goPackagePath}.git";
      rev = "v1.4.2";
      sha256 = "06wfg1mmzjj04z7d0q1x2fai9k6hm957brngsaf02fa9a3qqanv3";
    };
  }
  rec {
    goPackagePath = "github.com/pkg/errors";
    fetch = {
      type = "git";
      url = "https://${goPackagePath}.git";
      rev = "v0.8.0";
      sha256 = "001i6n71ghp2l6kdl3qq1v2vmghcz3kicv9a5wgcihrzigm75pp5";
    };
  }
  {
    goPackagePath = "golang.org/x/sys";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/sys";
      rev = "95c6576299259db960f6c5b9b69ea52422860fce";
      sha256 = "1fhq8bianb9a1iccpr92mi2hix9zvm10n0f7syx6vfbxdw32i316";
    };
  }
  {
    goPackagePath = "golang.org/x/text";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/text";
      rev = "3ba1a4dc141f5236b19ccbf2f67cb63d1a688d46";
      sha256 = "07sbakmman41p5hmdbf4y2wak0gh7k1z88m0zb72acsypp4179h1";
    };
  }
]
