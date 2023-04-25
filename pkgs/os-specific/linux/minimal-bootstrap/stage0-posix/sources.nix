{}:
{
  # Pinned from https://github.com/oriansj/stage0-posix/commit/4ad489ffc261ee036cfd33f20d939d7c5b05844e
  version = "unstable-2023-04-16";

  bootstrap-seeds-src = builtins.fetchTarball {
    url = "https://github.com/oriansj/bootstrap-seeds/archive/e4974affa1934274a8b8c29f19c87e758e650f52.tar.gz";
    sha256 = "0f325x9sixbv35b5s6cjd2qi41n84kmzia11n6w4r6rrldw6wci2";
  };

  m2-mesoplanet-src = builtins.fetchTarball {
    url = "https://github.com/oriansj/M2-Mesoplanet/archive/4bf3e2eded821cf9b69fd63a033272197a8703f7.tar.gz";
    sha256 = "0db13grmxg5hp1jj8vss2ms9c7znk319pkhmnd1ygzg5w8i2v0cj";
  };

  m2-planet-src = builtins.fetchTarball {
    url = "https://github.com/oriansj/M2-Planet/archive/f02aaaf67bf004eccd5fd0efb33ced481a0d8346.tar.gz";
    sha256 = "0bysizqr8nffzzjq6m59gs1m5z2smwfbymijjkxr3l8rxx819vck";
  };

  m2libc = builtins.fetchTarball {
    url = "https://github.com/oriansj/M2libc/archive/1139b2bbf5f9c2618e52298917460ec75c345451.tar.gz";
    sha256 = "113bsmpas8iwflnyjh34ap0p0y23bgdkca9viz9l87kwjbag5y4p";
  };

  mescc-tools-src = builtins.fetchTarball {
    url = "https://github.com/oriansj/mescc-tools/archive/3f941824677d74b30d80de08436d63b783adc17f.tar.gz";
    sha256 = "0cl5934giah2hdzi5q3w3qmkhpm7gx9qjc7nhbwvs3gbmq10nk36";
  };

  mescc-tools-extra-src = builtins.fetchTarball {
    url = "https://github.com/oriansj/mescc-tools-extra/archive/ec53af69d6d2119b47b369cd0ec37ac806e7ad60.tar.gz";
    sha256 = "1kn8mpx104ij9gxifl10dbyalizyn3ifszj5i3msidvr5k7ciay1";
  };

  stage0-posix-x86-src = builtins.fetchTarball {
    url = "https://github.com/oriansj/stage0-posix-x86/archive/56e6b8df3e95f4bc04f8b420a4cd8c82c70b9efa.tar.gz";
    sha256 = "0fih58js6kpflbx9bkl3ikpmbxljlfpg36s78dnaiy6nim36aw7d";
  };
}
