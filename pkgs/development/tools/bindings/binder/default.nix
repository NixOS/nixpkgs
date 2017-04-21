{ runCommand
, fetchFromGitHub
, llvmPackages_38
}:

# Installation instructions
# http://cppbinder.readthedocs.io/en/latest/install.html

let
  # Binder source
  version = "2017-03-27";

  # Binder source in tarball including required CMakeLists.txt
  binder_packaged_src = let
    binder_src = fetchFromGitHub {
      owner = "RosettaCommons";
      repo = "binder";
      rev = "dababfe3e12569ac4371502286811e6fb1926ef3";
      sha256 = "04bldqg6v0cbb42rjv12zwl56rx7nkvlm5xwm5hi3qva5z7i535b";
      #name = src_name;
    };
    # Because of an issue with the vendored copy of fmt we use
    # an original version.
    # https://github.com/RosettaCommons/binder/issues/19
    fmt_src = fetchFromGitHub {
      owner = "fmtlib";
      repo = "fmt";
      rev = "3.0.1";
      sha256 = "1r5lrdkfk0ljbwxnq5jhx6cdli83a8lixrgnzg0xamwjn4v4mm6w";
    };
    # Our clang expression expects the following name clang-tools-extra-*
    binder_src_name = "clang-tools-extra-binder";

   in runCommand (binder_src_name + ".tar.gz") {} ''
     unpackFile ${fmt_src}
     unpackFile ${binder_src}
     mv fmt* fmt
     mv binder* binder
     chmod -R u+w fmt
     chmod -R u+w binder

     rm -rf binder/binder/fmt
     cp -r fmt/fmt binder/binder/fmt
     echo 'add_subdirectory(binder)' > binder/CMakeLists.txt

     mv binder ${binder_src_name}
     tar -zcf $out ${binder_src_name}
  '';

in (llvmPackages_38.clang-unwrapped.override {
#   inherit python;
  clang-tools-extra_src = binder_packaged_src;
}).overrideAttrs (old: {
  name = "binder-${version}";
  NIX_CFLAGS_COMPILE="-fexceptions";

  postInstall = old.postInstall + ''
    mv bin/binder $out/bin/binder
  '';
})
