{
  "chunky_png" = {
    version = "1.3.4";
    source = {
      type = "gem";
      sha256 = "0n5xhkj3vffihl3h9s8yjzazqaqcm4p1nyxa1w2dk3fkpzvb0wfw";
    };
  };
  "compass" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "0lfi83w8z75czr0pf0rmj9hda22082h3cmvczl8r1ma9agf88y2c";
    };
    dependencies = [
      "chunky_png"
      "compass-core"
      "compass-import-once"
      "rb-fsevent"
      "rb-inotify"
      "sass"
    ];
  };
  "compass-core" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "0yaspqwdmzwdcqviclbs3blq7an16pysrfzylz8q1gxmmd6bpj3a";
    };
    dependencies = [
      "multi_json"
      "sass"
    ];
  };
  "compass-import-once" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "0bn7gwbfz7jvvdd0qdfqlx67fcb83gyvxqc7dr9fhcnks3z8z5rq";
    };
    dependencies = [
      "sass"
    ];
  };
  "ffi" = {
    version = "1.9.8";
    source = {
      type = "gem";
      sha256 = "0ph098bv92rn5wl6rn2hwb4ng24v4187sz8pa0bpi9jfh50im879";
    };
  };
  "multi_json" = {
    version = "1.11.0";
    source = {
      type = "gem";
      sha256 = "1mg3hp17ch8bkf3ndj40s50yjs0vrqbfh3aq5r02jkpjkh23wgxl";
    };
  };
  "rb-fsevent" = {
    version = "0.9.4";
    source = {
      type = "gem";
      sha256 = "12if5xsik64kihxf5awsyavlp595y47g9qz77vfp2zvkxgglaka7";
    };
  };
  "rb-inotify" = {
    version = "0.9.5";
    source = {
      type = "gem";
      sha256 = "0kddx2ia0qylw3r52nhg83irkaclvrncgy2m1ywpbhlhsz1rymb9";
    };
    dependencies = [
      "ffi"
    ];
  };
  "sass" = {
    version = "3.4.13";
    source = {
      type = "gem";
      sha256 = "0wxkjm41xr77pnfi06cbwv6vq0ypbni03jpbpskd7rj5b0zr27ig";
    };
  };
}